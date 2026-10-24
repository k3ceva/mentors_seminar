package main

import "fmt"

func main() {
	var balance float64
	fmt.Print("Введите начальный баланс: ")
	if _, err := fmt.Scan(&balance); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}
	if balance < 0 {
		fmt.Println("Баланс не может быть отрицательным")
		return
	}

	for {
		fmt.Println()
		fmt.Println("1 — посмотреть баланс")
		fmt.Println("2 — пополнить баланс")
		fmt.Println("3 — снять средства")
		fmt.Println("4 — выход")
		fmt.Print("Выберите действие: ")

		var choice int
		if _, err := fmt.Scan(&choice); err != nil {
			fmt.Println("Ошибка ввода:", err)
			return
		}

		switch choice {
		case 1:
			fmt.Printf("Ваш баланс: %.2f\n", balance)
		case 2:
			var amount float64
			fmt.Print("Введите сумму пополнения: ")
			if _, err := fmt.Scan(&amount); err != nil {
				fmt.Println("Ошибка ввода:", err)
				return
			}
			if amount <= 0 {
				fmt.Println("Сумма должна быть положительной")
				continue
			}
			balance += amount
			fmt.Printf("Баланс пополнен. Текущий баланс: %.2f\n", balance)
		case 3:
			var amount float64
			fmt.Print("Введите сумму снятия: ")
			if _, err := fmt.Scan(&amount); err != nil {
				fmt.Println("Ошибка ввода:", err)
				return
			}
			if amount <= 0 {
				fmt.Println("Сумма должна быть положительной")
				continue
			}
			if amount > balance {
				fmt.Println("Недостаточно средств на балансе")
				continue
			}
			balance -= amount
			fmt.Printf("Средства сняты. Текущий баланс: %.2f\n", balance)
		case 4:
			fmt.Println("Работа завершена")
			return
		default:
			fmt.Println("Неизвестная операция")
		}
	}
}
