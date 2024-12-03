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

	var splitLines [][]int
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

		splitLines = append(splitLines, split_line)
	}

	total := 0
	for _, line := range splitLines {

	}

	fmt.Printf("Day 2 Part 1 total: %d\n", total)

	// total = 0
	// for _, line := range splitLines {
	// }
	// fmt.Printf("Day 2 Part 2 total: %d\n", total)
}
