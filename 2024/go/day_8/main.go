package main

import (
	"advent_of_code/utils"
	"fmt"
)

const inputName = "input"

// Row, column
var input [][]byte
var numRows int
var numCols int

// Flattened Row, column
var antinodes []bool

// Array of slice of tower positions.
// The first index is the ascii value of the tower char.
var towers [256][][2]int

func main() {
	parse()

	total := part1()
	fmt.Printf("Day 6 Part 1 total: %d\n", total)

	total = part2()
	fmt.Printf("Day 6 Part 2 total: %d\n", total)
}

func part1() int {
	for _, towerSlice := range towers {
		for i, towerPos1 := range towerSlice {
			for _, towerPos2 := range towerSlice[i+1:] {
				antinodePos1 := [2]int{towerPos2[0] + towerPos2[0] - towerPos1[0], towerPos2[1] + towerPos2[1] - towerPos1[1]}
				if antinodePos1[0] >= 0 && antinodePos1[0] < numRows && antinodePos1[1] >= 0 && antinodePos1[1] < numCols {
					antinodes[antinodePos1[0]*numRows+antinodePos1[1]] = true
				}

				antinodePos2 := [2]int{towerPos1[0] + towerPos1[0] - towerPos2[0], towerPos1[1] + towerPos1[1] - towerPos2[1]}
				if antinodePos2[0] >= 0 && antinodePos2[0] < numRows && antinodePos2[1] >= 0 && antinodePos2[1] < numCols {
					antinodes[antinodePos2[0]*numRows+antinodePos2[1]] = true
				}
			}
		}
	}

	total := 0
	for _, antinode := range antinodes {
		if antinode {
			total += 1
		}
	}
	return total
}

func part2() int {
	for _, towerSlice := range towers {
		for i, towerPos1 := range towerSlice {
			for _, towerPos2 := range towerSlice[i+1:] {
				step_1_to_2 := [2]int{towerPos2[0] - towerPos1[0], towerPos2[1] - towerPos1[1]}

				for antinodePos1 := towerPos2; antinodePos1[0] >= 0 && antinodePos1[0] < numRows && antinodePos1[1] >= 0 && antinodePos1[1] < numCols; {
					antinodes[antinodePos1[0]*numRows+antinodePos1[1]] = true
					antinodePos1[0] += step_1_to_2[0]
					antinodePos1[1] += step_1_to_2[1]
				}

				for antinodePos2 := towerPos1; antinodePos2[0] >= 0 && antinodePos2[0] < numRows && antinodePos2[1] >= 0 && antinodePos2[1] < numCols; {
					antinodes[antinodePos2[0]*numRows+antinodePos2[1]] = true
					antinodePos2[0] -= step_1_to_2[0]
					antinodePos2[1] -= step_1_to_2[1]
				}
			}
		}
	}

	total := 0
	for _, antinode := range antinodes {
		if antinode {
			total += 1
		}
	}
	return total
}

func parse() {
	input = utils.ReadBytesByLine(inputName)
	numRows = len(input)
	numCols = len(input[0])
	antinodes = make([]bool, numRows*numCols)
	for row, line := range input {
		for col, c := range line {
			if c != '.' {
				towers[int(c)] = append(towers[int(c)], [2]int{row, col})
			}
		}
	}

}

