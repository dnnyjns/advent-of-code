package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type Policy struct {
	Character string
	Password  string
	Rule1     int
	Rule2     int
}

func (p *Policy) ValidByLimit() bool {
	count := strings.Count(p.Password, p.Character)
	return count >= p.Rule1 && count <= p.Rule2
}

func (p *Policy) ValidByPosition() bool {
	pos1 := string(p.Password[p.Rule1-1]) == p.Character
	pos2 := string(p.Password[p.Rule2-1]) == p.Character
	return pos1 != pos2
}

var myExp = regexp.MustCompile(`(?P<limit>\d+-\d+)\s(?P<character>[A-Za-z]):\s(?P<password>.+)`)

func main() {
	policies, err := readPolicies()
	if err != nil {
		panic(err)
	}

	part1 := 0
	part2 := 0

	for _, policy := range policies {

		if policy.ValidByLimit() {
			part1++
		}
		if policy.ValidByPosition() {
			part2++
		}

	}

	fmt.Println("How many passwords are valid according to their policies?")
	fmt.Println("Part 1: ", part1)
	fmt.Println("Part 2: ", part2)
}

func readPolicies() ([]*Policy, error) {
	policies := make([]*Policy, 0)
	file, err := os.Open("./day02.txt")
	if err != nil {
		return policies, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		policy := newPolicy(scanner.Text())
		policies = append(policies, policy)
	}

	if err := scanner.Err(); err != nil {
		return policies, err
	}

	return policies, nil
}

func newPolicy(data string) *Policy {
	match := myExp.FindStringSubmatch(data)

	limit := match[myExp.SubexpIndex("limit")]
	character := match[myExp.SubexpIndex("character")]
	password := match[myExp.SubexpIndex("password")]

	split := strings.Split(limit, "-")
	rule1, _ := strconv.Atoi(split[0])
	rule2, _ := strconv.Atoi(split[1])

	return &Policy{
		Character: character,
		Password:  password,
		Rule1:     rule1,
		Rule2:     rule2,
	}
}
