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

	sum := num
	max, min := num, num
	even, odd := 0, 0
	if num%2 == 0 {
		even++
	} else {
		odd++
	}

	for i := 2; i <= n; i++ {
		fmt.Printf("Введите число %d: ", i)
		if _, err := fmt.Scan(&num); err != nil {
			fmt.Println("Ошибка ввода:", err)
			return
		}
		sum += num
		if num > max {
			max = num
		}
		if num < min {
			min = num
		}
		if num%2 == 0 {
			even++
		} else {
			odd++
		}
	}

	avg := float64(sum) / float64(n)
	fmt.Println("Сумма:", sum)
	fmt.Printf("Среднее: %.2f\n", avg)
	fmt.Println("Максимум:", max)
	fmt.Println("Минимум:", min)
	fmt.Println("Чётных:", even)
	fmt.Println("Нечётных:", odd)
}
