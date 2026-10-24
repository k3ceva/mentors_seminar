package main

import "fmt"

func main() {
	var n int
	fmt.Print("Введите число N: ")
	if _, err := fmt.Scan(&n); err != nil {
		fmt.Println("Ошибка ввода:", err)
		return
	}

	if n > 0 {
		fmt.Println("Число положительное")
	} else if n < 0 {
		fmt.Println("Число отрицательное")
	} else {
		fmt.Println("Число равно нулю")
	}

	if n%2 == 0 {
		fmt.Println("Число чётное")
	} else {
		fmt.Println("Число нечётное")
	}

	div3 := n%3 == 0
	div5 := n%5 == 0
	switch {
	case div3 && div5:
		fmt.Println("Число делится на 3 и на 5")
	case div3:
		fmt.Println("Число делится на 3")
	case div5:
		fmt.Println("Число делится на 5")
	default:
		fmt.Println("Число не делится ни на 3, ни на 5")
	}
}
