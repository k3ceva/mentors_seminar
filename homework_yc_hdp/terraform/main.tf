terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-d"
}

resource "yandex_vpc_network" "hdp-network" {
  name = "vpc-network-for-terra-hadoop"
}

resource "yandex_vpc_gateway" "hdp-gw" {
  name = "hdp-gw"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "hdp-routetable" {
  network_id = yandex_vpc_network.hdp-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.hdp-gw.id
  }
}

resource "yandex_vpc_subnet" "hdp-subnet" {
  name           = "vpc-subnet-for-terra-hadoop"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.hdp-network.id
  v4_cidr_blocks = ["10.0.0.0/22"]
  route_table_id = yandex_vpc_route_table.hdp-routetable.id
}

resource "yandex_vpc_security_group" "hdp-security-group" {
  description = "Security group for DataProc"
  name        = "hdp-security-group"
  network_id  = yandex_vpc_network.hdp-network.id

  egress {
    description    = "Allow outgoing HTTPS traffic"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "ssh"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "Allow any incomging traffic within the security group"
    protocol          = "ANY"
    from_port         = 0
    to_port           = 65535
    predefined_target = "self_security_group"
  }

  egress {
    description       = "Allow any outgoing traffic within the security group"
    protocol          = "ANY"
    from_port         = 0
    to_port           = 65535
    predefined_target = "self_security_group"
  }

  egress {
    description    = "Allow outgoing traffic to NTP servers for time synchronization"
    protocol       = "UDP"
    port           = 123
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_iam_service_account" "sa-terra-hdp" {
  name        = "sa-terra-hdp"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-terra-hdp-dataproc-agent" {
  depends_on = [
    yandex_iam_service_account.sa-terra-hdp
  ]
  folder_id = "b1g802d8a4te1htbhlok"
  role      = "dataproc.agent"
  member    = "serviceAccount:${yandex_iam_service_account.sa-terra-hdp.id}"
}

resource "yandex_iam_service_account" "sa-terra-sds4hdp" {
  name        = "sa-terra-sds4hdp"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-terra-sds4hdp-storage-admin" {
  depends_on = [
    yandex_iam_service_account.sa-terra-sds4hdp
  ]
  folder_id = "b1g802d8a4te1htbhlok"
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-terra-sds4hdp.id}"
}

resource "yandex_lockbox_secret" "sa-terra-sds4hdp-vault" {
  depends_on = [
    yandex_iam_service_account.sa-terra-sds4hdp
  ]
  name      = "sa-terra-sds4hdp-vault"
  folder_id = "b1g802d8a4te1htbhlok"
  deletion_protection = false
}

resource "yandex_iam_service_account_static_access_key" "sa-terra-sds4hdp-s3-creds" {

  service_account_id = yandex_iam_service_account.sa-terra-sds4hdp.id
  
  depends_on = [
    yandex_lockbox_secret.sa-terra-sds4hdp-vault,
    yandex_iam_service_account.sa-terra-sds4hdp
  ]

  output_to_lockbox  {
    secret_id             = yandex_lockbox_secret.sa-terra-sds4hdp-vault.id
    entry_for_access_key  = "s3_access_key"
    entry_for_secret_key  = "s3_secret_key"
  }
}

resource "time_sleep" "vault_delay" {
  depends_on = [
    yandex_iam_service_account_static_access_key.sa-terra-sds4hdp-s3-creds
  ]
  create_duration = "10s"
}

data "yandex_lockbox_secret" "s3_secret_key" {
  depends_on = [
    time_sleep.vault_delay
  ]
  secret_id = yandex_lockbox_secret.sa-terra-sds4hdp-vault.id
}

data "yandex_lockbox_secret_version" "s3_secret_key_version" {
  depends_on = [
    time_sleep.vault_delay
  ]
  secret_id  = yandex_lockbox_secret.sa-terra-sds4hdp-vault.id
}



resource "yandex_storage_bucket" "hse-s3-bucket" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.sa-terra-sds4hdp-storage-admin,
    data.yandex_lockbox_secret_version.s3_secret_key_version
  ]

  folder_id = "b1g802d8a4te1htbhlok"
  bucket     = "hse-s3-bucket"
  max_size              = 1073741824
  default_storage_class = "standard"
  force_destroy = true

  
  access_key = data.yandex_lockbox_secret_version.s3_secret_key_version.entries[
            index(data.yandex_lockbox_secret_version.s3_secret_key_version.entries.*.key, "s3_access_key")
          ]["text_value"]
  secret_key = data.yandex_lockbox_secret_version.s3_secret_key_version.entries[
            index(data.yandex_lockbox_secret_version.s3_secret_key_version.entries.*.key, "s3_secret_key")
          ]["text_value"]
}

resource "yandex_storage_bucket_grant" "grant-sa-terra-hdp" {

  depends_on = [
    yandex_storage_bucket.hse-s3-bucket
  ]

  bucket = yandex_storage_bucket.hse-s3-bucket.bucket

  grant {
    id          = yandex_iam_service_account.sa-terra-hdp.id
    type        = "CanonicalUser"
    permissions = ["READ","WRITE"]
  }

}

resource "yandex_dataproc_cluster" "yc-hdp" {
  bucket                         = yandex_storage_bucket.hse-s3-bucket.bucket
  name                           = "yc-hdp"
  environment                    = "PRESTABLE"
  service_account_id             = yandex_iam_service_account.sa-terra-hdp.id
  zone_id                        = "ru-central1-d"
  security_group_ids             = [yandex_vpc_security_group.hdp-security-group.id]
  deletion_protection            = false
  ui_proxy                       = true

  depends_on = [
    yandex_resourcemanager_folder_iam_member.sa-terra-hdp-dataproc-agent
  ]

  cluster_config {
    version_id = "2.1"

    hadoop {
      services   = ["HDFS", "YARN", "SPARK", "ZEPPELIN"]
      ssh_public_keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtnZjmb7Yrd24O99zqbi29eGgYhro92P2MJc3ZhremC k3ceva"
      ]
    }

    subcluster_spec {
      name = "NN"
      role = "MASTERNODE"
      resources {
        resource_preset_id = "s4a-c4-m16"
        disk_type_id       = "network-ssd"
        disk_size          = 64
      }
      subnet_id   = yandex_vpc_subnet.hdp-subnet.id
      hosts_count = 1
    }

    subcluster_spec {
      name = "DN"
      role = "DATANODE"
      resources {
        resource_preset_id = "c4a-c4-m8"
        disk_type_id       = "network-hdd"
        disk_size          = 64
      }
      subnet_id   = yandex_vpc_subnet.hdp-subnet.id
      hosts_count = 3
    }
  }
}
