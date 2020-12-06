// --- Day 5: Binary Boarding ---
// https://adventofcode.com/2020/day/5

package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"sort"
	"strings"
)

type BoardingPass struct {
	Data string
}

func (bp *BoardingPass) SeatID() int {
	return (bp.findRow() * 8) + bp.findColumn()
}

func (bp *BoardingPass) findRow() int {
	return bp.bsearch(bp.Data[0:7], "F", "B")
}

func (bp *BoardingPass) findColumn() int {
	return bp.bsearch(bp.Data[7:10], "L", "R")
}

func (bp *BoardingPass) bsearch(value, lowerKey, upperKey string) int {
	lower := 0
	upper := int(math.Exp2(float64(len(value))) - 1)
	split := strings.Split(value, "")

	for _, key := range split {
		if key == lowerKey {
			upper = int(math.Floor(float64(upper-lower) / 2.0))
			upper += lower
		} else if key == upperKey {
			lower += int(math.Ceil(float64(upper-lower) / 2.0))
		}
	}

	return lower
}

func main() {
	boardingPasses, err := readBoardingPasses()
	if err != nil {
		panic(err)
	}

	sort.SliceStable(boardingPasses, func(i, j int) bool {
		return boardingPasses[i].SeatID() < boardingPasses[j].SeatID()
	})

	part1 := boardingPasses[len(boardingPasses)-1].SeatID()

	var part2 int
	for index, bp := range boardingPasses {
		if boardingPasses[index+1].SeatID() == bp.SeatID()+2 {
			part2 = bp.SeatID() + 1
			break
		}
	}

	fmt.Println("--- Day 5: Binary Boarding ---")
	fmt.Println("Part 1:", part1)
	fmt.Println("Part 2:", part2)
}

func readBoardingPasses() ([]BoardingPass, error) {
	boardingPasses := make([]BoardingPass, 0)
	file, err := os.Open("./day05.txt")
	if err != nil {
		return boardingPasses, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		boardingPasses = append(boardingPasses, BoardingPass{Data: scanner.Text()})
	}

	if err := scanner.Err(); err != nil {
		return boardingPasses, err
	}

	return boardingPasses, nil
}
