package main

import (
	"advent_of_code/utils"
	"fmt"
)

const inputName = "input"

var lineLen int
var numLines int
var input [][]byte

func main() {
	input = utils.ReadBytesByLine(inputName)
	numLines = len(input)
	lineLen = len(input[0])

	total := part1()
	fmt.Printf("Day 4 Part 1 total: %d\n", total)

	total = part2()
	fmt.Printf("Day 4 Part 2 total: %d\n", total)
}

func part1() int {
	total := 0
	for i, line := range input {
		for j, c := range line {
			if c == 'X' {
				if isXmasInDir(j, i, 1, 0) {
					total += 1
				}
				if isXmasInDir(j, i, -1, 0) {
					total += 1
				}
				if isXmasInDir(j, i, 0, 1) {
					total += 1
				}
				if isXmasInDir(j, i, 0, -1) {
					total += 1
				}
				if isXmasInDir(j, i, 1, 1) {
					total += 1
				}
				if isXmasInDir(j, i, -1, -1) {
					total += 1
				}
				if isXmasInDir(j, i, -1, 1) {
					total += 1
				}
				if isXmasInDir(j, i, 1, -1) {
					total += 1
				}
			}
		}
	}
	return total
}

func isXmasInDir(xpos, ypos, xdir, ydir int) bool {
	if xpos+3*xdir < 0 || xpos+3*xdir >= lineLen || ypos+3*ydir < 0 || ypos+3*ydir >= numLines {
		return false
	}

	newx := xpos + xdir
	newy := ypos + ydir
	if input[newy][newx] != 'M' {
		return false
	}

	newx = newx + xdir
	newy = newy + ydir
	if input[newy][newx] != 'A' {
		return false
	}

	newx = newx + xdir
	newy = newy + ydir
	if input[newy][newx] != 'S' {
		return false
	}
	return true
}

func part2() int {
	total := 0
	for i, line := range input {
		for j, c := range line {
			if c == 'A' && isMasXAt(j, i) {
				total += 1
			}
		}
	}
	return total
}

func isMasXAt(xpos, ypos int) bool {
	if xpos-1 < 0 || xpos+1 >= lineLen || ypos-1 < 0 || ypos+1 >= numLines {
		return false
	}

	if input[ypos+1][xpos+1] == 'M' {
		if input[ypos+1][xpos-1] == 'M' {
			return input[ypos-1][xpos-1] == 'S' && input[ypos-1][xpos+1] == 'S'
		} else if input[ypos-1][xpos+1] == 'M' {
			return input[ypos-1][xpos-1] == 'S' && input[ypos+1][xpos-1] == 'S'
		}
		return false
	}

	if input[ypos-1][xpos-1] == 'M' {
		if input[ypos+1][xpos-1] == 'M' {
			return input[ypos-1][xpos+1] == 'S' && input[ypos+1][xpos+1] == 'S'
		} else if input[ypos-1][xpos+1] == 'M' {
			return input[ypos+1][xpos-1] == 'S' && input[ypos+1][xpos+1] == 'S'
		} else {
			return false
		}
	}

	return false
}
