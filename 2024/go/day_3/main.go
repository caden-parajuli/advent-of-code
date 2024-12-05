package main

import (
	"advent_of_code/utils"
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

const inputName = "input"
const do = "do()"
const dont = "don't()"
var mulRe = regexp.MustCompile(`mul\(([\d]*),([\d]*)\)`)
var cutRe = regexp.MustCompile(`don't\(\)(?s).*?do\(\)`)

func main() {
	input := utils.ReadString(inputName)

	total := part1(input)
	fmt.Printf("Day 2 Part 1 total: %d\n", total)

	total = part2(input)
	fmt.Printf("Day 2 Part 2 total: %d\n", total)
}

func part1(input string) int {
	total := 0
	for _, line := range mulRe.FindAllStringSubmatch(input, -1) {
		m1, _ := strconv.Atoi(line[1])
		m2, _ := strconv.Atoi(line[2])
		total += m1 * m2
	}
	return total
}

func part2(input string) int {
	// remove don't()...do()
	input = cutRe.ReplaceAllLiteralString(input, "")

	// Remove any trailing don't
	dontInd := strings.Index(input, dont)
	if dontInd != -1 {
		input = input[:dontInd]
	}

	return part1(input)
}
