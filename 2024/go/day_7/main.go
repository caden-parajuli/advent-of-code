package main

import (
	"advent_of_code/utils"
	"fmt"
	"strconv"
	"strings"
)

const inputName = "input"

var input []string

func main() {
	input = utils.ReadByLine(inputName)

	total := part1()
	fmt.Printf("Day 6 Part 1 total: %d\n", total)

	total = part2()
	fmt.Printf("Day 6 Part 2 total: %d\n", total)
}

func part1() int {
	total := 0
	for _, line := range input {
		parts := strings.Fields(line)

		test_value, err := strconv.Atoi(parts[0][:len(parts[0])-1])
		if err != nil {
			panic(err)
		}

		var part_nums []int
		for _, part := range parts[1:] {
			part_num, err := strconv.Atoi(part)
			if err != nil {
				panic(err)
			}
			part_nums = append(part_nums, part_num)
		}

		if canBeValid1(test_value, part_nums) {
			total += test_value
		}
	}

	return total
}

func part2() int {
	total := 0
	for _, line := range input {
		parts := strings.Fields(line)

		test_value, err := strconv.Atoi(parts[0][:len(parts[0])-1])
		if err != nil {
			panic(err)
		}

		var part_nums []int
		for _, part := range parts[1:] {
			part_num, err := strconv.Atoi(part)
			if err != nil {
				panic(err)
			}
			part_nums = append(part_nums, part_num)
		}

		if canBeValid2(test_value, part_nums) {
			total += test_value
		}
	}

	return total
}

func canBeValid1(test_value int, part_nums []int) bool {
	if len(part_nums) == 0 {
		return test_value == 0
	}

	last_index := len(part_nums) - 1
	part := part_nums[last_index]

	return (test_value%part == 0 && canBeValid1(test_value/part, part_nums[:last_index])) ||
		canBeValid1(test_value-part, part_nums[:last_index])
}


func canBeValid2(test_value int, part_nums []int) bool {
	if len(part_nums) == 0 {
		return test_value == 0
	}

	last_index := len(part_nums) - 1
	part := part_nums[last_index]
	remaining := part_nums[:last_index]

	can_concat, unconcat := endsWith(test_value, part)
	divisible := test_value%part == 0
	subtractible := test_value >= part

	return (can_concat && canBeValid2(unconcat, remaining)) ||
		(divisible && canBeValid2(test_value/part, remaining)) ||
		(subtractible && canBeValid2(test_value-part, remaining))

}

func endsWith(test_value int, part int) (bool, int) {
	// Get the smallest power of 10 greater or equal to part
	pow10 := 1
	for pow10 <= part {
		pow10 *= 10
	}

	return (test_value%pow10 == part), test_value / pow10
}
