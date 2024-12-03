package main

import (
	"advent_of_code/utils"
	"fmt"
	"strconv"
	"strings"
)

const input = "input"

func main() {
	lines := utils.ReadByLine(input)

	var reports [][]int
	for _, line := range lines {
		var split_line []int

		fields := strings.Fields(line)
		for _, field := range fields {
			part1, err := strconv.Atoi(field)
			if err != nil {
				panic(err)
			}
			split_line = append(split_line, part1)
		}

		reports = append(reports, split_line)
	}

	total := 0
	for _, report := range reports {
		if isSafe1(report) {
			total++
		}
	}
	fmt.Printf("Day 2 Part 1 total: %d\n", total)

	total = 0
	for _, report := range reports {
		if isSafe2(report) {
			total++
		}
	}
	fmt.Printf("Day 2 Part 2 total: %d\n", total)
}

func isSafe1(report []int) bool {
	isIncreasing := report[1] > report[0]
	// println(isIncreasing)
	last := -1
	for _, level := range report {
		if last == -1 {
			last = level
			continue
		}

		if isIncreasing != (last < level) {
			return false
		}

		diff := utils.AbsDiff(last, level)

		if diff < 1 || diff > 3 {
			return false
		}

		last = level
	}

	return true
}

func isSafe2(report []int) bool {
	if isSafe1(report) {
		return true
	}
	for i := range len(report) {
		if isSafe1(removeIndex(report, i)) {
			return true
		}
	}
	return false
}

func removeIndex(s []int, index int) []int {
    ret := make([]int, 0)
    ret = append(ret, s[:index]...)
    return append(ret, s[index+1:]...)
}
