package main

import "fmt"

func main() {
	var n int
	fmt.Print("Введите число N: ")
	if _, err := fmt.Scan(&n); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}

	sum := 0
	for i := 1; i <= n; i++ {
		if i%2 == 0 && i%3 == 0 {
			sum += i
		}
	}

	fmt.Println("Сумма чётных чисел, делящихся на 3, от 1 до", n, "=", sum)
}
