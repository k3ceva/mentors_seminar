package main

import "fmt"

func main() {
	var a, b float64
	var op string

	fmt.Print("Введите первое число: ")
	if _, err := fmt.Scan(&a); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}

	fmt.Print("Введите второе число: ")
	if _, err := fmt.Scan(&b); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}

	fmt.Print("Введите операцию (+, -, *, /): ")
	if _, err := fmt.Scan(&op); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}

	switch op {
	case "+":
		fmt.Printf("%.2f + %.2f = %.2f\n", a, b, a+b)
	case "-":
		fmt.Printf("%.2f - %.2f = %.2f\n", a, b, a-b)
	case "*":
		fmt.Printf("%.2f * %.2f = %.2f\n", a, b, a*b)
	case "/":
		if b == 0 {
			fmt.Println("Ошибка: деление на ноль")
			return
		}
		fmt.Printf("%.2f / %.2f = %.2f\n", a, b, a/b)
	default:
		fmt.Println("Неизвестная операция:", op)
	}
}
