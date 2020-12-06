//  --- Day 3: Toboggan Trajectory ---
//  https://adventofcode.com/2020/day/3

package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	grid, err := readGrid()
	if err != nil {
		panic(err)
	}

	part1 := countTrees(grid, 3, 1)
	part2 := 1
	pairs := [5][2]int{
		{1, 1},
		{3, 1},
		{5, 1},
		{7, 1},
		{1, 2},
	}

	for _, pair := range pairs {
		part2 *= countTrees(grid, pair[0], pair[1])
	}

	fmt.Println("--- Day 3: Toboggan Trajectory ---")
	fmt.Println("Part 1: ", part1)
	fmt.Println("Part 2: ", part2)
}

func countTrees(grid [][]string, right, down int) (treeCount int) {
	currentRight := right
	currentDown := down

	for index, row := range grid {
		if index != currentDown {
			continue
		}

		if row[currentRight%len(row)] == "#" {
			treeCount++
		}

		currentRight += right
		currentDown += down
	}

	return
}

func readGrid() ([][]string, error) {
	grid := make([][]string, 0)
	file, err := os.Open("./day03.txt")
	if err != nil {
		return grid, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		policy := strings.Split(scanner.Text(), "")
		grid = append(grid, policy)
	}

	if err := scanner.Err(); err != nil {
		return grid, err
	}

	return grid, nil
}
