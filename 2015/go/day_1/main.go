package main

import (
	"advent_of_code/utils"
	"fmt"
)

const input = "input"

func main() {
	bytes := utils.ReadBytes(input)

	part2Answer := 0
	total := 0
	for i, byte := range bytes {
		if byte == '(' {
			total++
		} else if byte == ')' {
			total--
		}

		if total == -1 && part2Answer == 0 {
			part2Answer = i + 1
		}
	}
	fmt.Printf("Part 1 answer: %d\n", total)
	fmt.Printf("Part 2 answer: %d\n", part2Answer)
}
