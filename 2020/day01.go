package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

type Expenses = map[int]struct{}

func main() {
	expenses, err := readExpenses()
	if err != nil {
		panic(err)
	}

	expense1, expense2, ok := findTwo(expenses, 2020)
	if ok {
		fmt.Printf("Part1 = %d\n", expense1*expense2)
	}

	expense1, expense2, expense3, ok := findThree(expenses, 2020)
	if ok {
		fmt.Printf("Part2 = %d\n", expense1*expense2*expense3)
	}
}

func readExpenses() (Expenses, error) {
	expenses := make(Expenses)
	file, err := os.Open("./inputs/day01.txt")
	if err != nil {
		return expenses, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		i, err := strconv.Atoi(scanner.Text())
		if err != nil {
			return expenses, err
		}
		expenses[i] = struct{}{}
	}

	if err := scanner.Err(); err != nil {
		return expenses, err
	}

	return expenses, nil
}

func findTwo(expenses Expenses, target int) (int, int, bool) {
	for expense1 := range expenses {
		expense2 := target - expense1
		_, ok := expenses[expense2]
		if ok {
			return expense1, expense2, true

		}
	}

	return 0, 0, false
}

func findThree(expenses Expenses, target int) (int, int, int, bool) {
	for expense1 := range expenses {
		expense2, expense3, ok := findTwo(expenses, target-expense1)
		if ok {
			return expense1, expense2, expense3, true

		}
	}

	return 0, 0, 0, false
}
