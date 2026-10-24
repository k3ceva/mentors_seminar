package main

import "fmt"

func main() {
	var n int
	fmt.Print("Введите число N: ")
	if _, err := fmt.Scan(&n); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}
	if n < 1 {
		fmt.Println("N должно быть не меньше 1")
		return
	}

	sum := 0
	for i := 1; i <= n; i++ {
		sum += i
	}
	avg := float64(sum) / float64(n)

	fmt.Println("Сумма чисел от 1 до", n, "=", sum)
	fmt.Printf("Среднее значение = %.2f\n", avg)
}
