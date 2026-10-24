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

	var num int
	fmt.Print("Введите число 1: ")
	if _, err := fmt.Scan(&num); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}
	max, min := num, num

	for i := 2; i <= n; i++ {
		fmt.Printf("Введите число %d: ", i)
		if _, err := fmt.Scan(&num); err != nil {
			fmt.Println("Ошибка ввода:", err)
			return
		}
		if num > max {
			max = num
		}
		if num < min {
			min = num
		}
	}

	fmt.Println("Максимальное:", max)
	fmt.Println("Минимальное:", min)
}
