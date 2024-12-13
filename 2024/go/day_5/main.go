package main

import (
	"advent_of_code/utils"
	"fmt"
	"slices"
	"strconv"
	"strings"
)

const inputName = "input"

var input []string
var mappings [][]int
var updates [][]int

func main() {
	input = utils.ReadByLine(inputName)
	parse()

	total := part1()
	fmt.Printf("Day 5 Part 1 total: %d\n", total)

	total = part2()
	fmt.Printf("Day 5 Part 2 total: %d\n", total)
}

func part1() int {
	total := 0
	for _, update := range updates {
		if slices.IsSortedFunc(update, compare) {
			total += update[len(update)/2]
		}
	}

	return total
}

func part2() int {
	total := 0
	for _, update := range updates {
		sortedUpdate := make([]int, len(update))
		copy(sortedUpdate, update)
		slices.SortStableFunc(sortedUpdate, compare)

		if !slices.Equal(update, sortedUpdate) {
			total += sortedUpdate[len(update)/2]
		}
	}

	return total
}

func compare(a, b int) int {
	if slices.Contains(mappings[a], b) {
		return -1
	} else if slices.Contains(mappings[b], a) {
		return 1
	} else {
		return 0
	}
}

func parse() {
	mappings = make([][]int, 100)

	var index int
	for i, line := range input {
		if line != "" {
			numstrs := strings.SplitN(line, "|", 2)
			num0, _ := strconv.Atoi(numstrs[0])
			num1, _ := strconv.Atoi(numstrs[1])
			mappings[num0] = append(mappings[num0], num1)
		} else {
			index = i
			break
		}
	}

	for _, line := range input[index+1:] {
		var update []int = nil

		for _, numstr := range strings.Split(line, ",") {
			num, _ := strconv.Atoi(numstr)
			update = append(update, num)
		}
		updates = append(updates, update)
	}
}
