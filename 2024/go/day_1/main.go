package main

import (
	"advent_of_code/utils"
	"fmt"
	"slices"
	"strconv"
	"strings"
)

const input = "input"

func main() {
	lines := utils.ReadByLine(input)
	var list1 []int
	var list2 []int
	for _, line := range lines {
		parts := strings.Fields(line)

		part1, err := strconv.Atoi(parts[0])
		if err != nil {
			panic(err)
		}
		part2, err := strconv.Atoi(parts[1])
		if err != nil {
			panic(err)
		}

		list1 = append(list1, part1)
		list2 = append(list2, part2)
	}

	slices.Sort(list1)
	slices.Sort(list2)

	total := 0
	for i := range len(list1) {
		total += utils.AbsDiff(list1[i], list2[i])
	}

	fmt.Printf("Day 1 Part 1 total: %d\n", total)

    total = 0
	i := 0
	j := 0
	last := 0
	for i < len(list1) {
		if last == list1[i] {
			i++
            continue
		}
        last = list1[i]
        count := 0

        for j < len(list2) && list1[i] > list2[j] {
            j++
        }
        for j < len(list2) && list1[i] == list2[j] {
            count++
            j++
        }

        total += last * count

        i++
	}

	fmt.Printf("Day 1 Part 2 total: %d\n", total)
}
