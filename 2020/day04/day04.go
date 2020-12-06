// --- Day 4: Passport Processing ---
// https://adventofcode.com/2020/day/4

package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type Validation func(value string) bool

var (
	heightCm  = regexp.MustCompile(`^(?P<height>\d+)cm$`)
	heightIn  = regexp.MustCompile(`^(?P<height>\d+)in$`)
	hclRegexp = regexp.MustCompile(`^#[a-z0-9]{6}$`)
	eclRegexp = regexp.MustCompile(`^(amb|blu|brn|gry|grn|hzl|oth)$`)
	pidRegexp = regexp.MustCompile(`^\d{9}$`)
	fields    = map[string]Validation{
		"byr": func(value string) bool {
			year, _ := strconv.Atoi(value)
			return year >= 1920 && year <= 2002
		},
		"iyr": func(value string) bool {
			year, _ := strconv.Atoi(value)
			return year >= 2010 && year <= 2020
		},
		"eyr": func(value string) bool {
			year, _ := strconv.Atoi(value)
			return year >= 2020 && year <= 2030
		},
		"hgt": func(value string) bool {
			if match := heightCm.FindStringSubmatch(value); len(match) > 0 {
				height, _ := strconv.Atoi(match[heightCm.SubexpIndex("height")])
				return height >= 150 && height <= 193
			} else if match := heightIn.FindStringSubmatch(value); len(match) > 0 {
				height, _ := strconv.Atoi(match[heightIn.SubexpIndex("height")])
				return height >= 59 && height <= 76
			}

			return false
		},
		"hcl": func(value string) bool {
			return hclRegexp.Match([]byte(value))
		},
		"ecl": func(value string) bool {
			return eclRegexp.Match([]byte(value))
		},
		"pid": func(value string) bool {
			return pidRegexp.Match([]byte(value))
		},
	}
)

type Passport map[string]string

func (p Passport) validPart1() bool {
	valid := true
	for field := range fields {
		_, ok := p[field]
		valid = valid && ok
	}
	return valid
}

func (p Passport) validPart2() bool {
	valid := true
	for field, validation := range fields {
		value, ok := p[field]
		valid = valid && ok && validation(value)
	}
	return valid
}

func main() {
	passports, err := readPassports()
	if err != nil {
		panic(err)
	}

	part1 := 0
	for _, passport := range passports {
		if passport.validPart1() {
			part1++
		}
	}

	part2 := 0
	for _, passport := range passports {
		if passport.validPart2() {
			part2++
		}
	}

	fmt.Println("--- Day 4: Passport Processing ---")
	fmt.Println("Part 1:", part1)
	fmt.Println("Part 2:", part2)
}

func readPassports() ([]Passport, error) {
	passports := make([]Passport, 0)
	file, err := os.Open("./day04.txt")
	if err != nil {
		return passports, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	currentPassport := make(Passport)
	for scanner.Scan() {
		pairs := strings.Split(scanner.Text(), " ")

		if len(pairs) == 1 && pairs[0] == "" {
			currentPassport = make(Passport)
			passports = append(passports, currentPassport)
		} else {
			for _, pair := range pairs {
				keyValue := strings.Split(pair, ":")
				currentPassport[keyValue[0]] = keyValue[1]
			}
		}
	}
	passports = append(passports, currentPassport)

	if err := scanner.Err(); err != nil {
		return passports, err
	}

	return passports, nil
}
