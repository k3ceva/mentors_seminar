# ●	Задание: Напишите Bash-скрипт, который выполняет следующие действия:
# 1.	Создаёт список всех файлов в текущей директории, указывая их тип (файл, каталог и т.д.).
# 2.	Проверяет наличие определённого файла, переданного как аргумент скрипта, и выводит сообщение о его наличии или отсутствии.
# 3.	Использует цикл for для вывода информации о каждом файле: его имя и права доступа.

declare -A scan_result
arg_file_found=0

# Создание списока всех файлов в текущей директории, указывая их тип
for file in *; do
    if [[ -f "$file" ]]; then
        type="файл"
        if [[ "$file" == "$1" ]]; then
            arg_file_found=1
        fi
    elif [[ -d "$file" ]]; then
        type="каталог"
    elif [[ -L "$file" ]]; then
        type="символическая ссылка"
    else
        type="неизвестный тип"
    fi

    scan_result["$file"]="$type"
done

# Проверка на наличие файла
if [[ $arg_file_found -eq 1 ]]; then
    echo "File $1 was found"
else
    echo "File $1 was not found"
fi

# Цикл вывода информации о каждом файле: его имя и права доступа
for key in "${!scan_result[@]}"; do
    access_rights=$(ls -ld "$key" | cut -d ' ' -f1)
    echo "$key $access_rights"
done
