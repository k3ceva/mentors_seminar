package main

import "fmt"

func main() {
	var n int
	fmt.Print("Введите количество чисел N: ")
	if _, err := fmt.Scan(&n); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}
	if n < 1 {
		fmt.Println("N должно быть не меньше 1")
		return
	}

	positive, negative, zero := 0, 0, 0
	for i := 1; i <= n; i++ {
		var num int
		fmt.Printf("Введите число %d: ", i)
		if _, err := fmt.Scan(&num); err != nil {
			fmt.Println("Ошибка ввода:", err)
			return
		}
		switch {
		case num > 0:
			positive++
		case num < 0:
			negative++
		default:
			zero++
		}
	}

	fmt.Println("Положительных:", positive)
	fmt.Println("Отрицательных:", negative)
	fmt.Println("Нулей:", zero)
}
