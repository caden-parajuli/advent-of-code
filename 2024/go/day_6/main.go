package main

import (
	"advent_of_code/utils"
	"fmt"
	"iter"
	"slices"
)

const inputName = "input"

// All Row, Col
var input [][]byte
var numRows int
var numCols int
var rowObsts [][]int
var colObsts [][]int
var startPos [2]int
var playerPos [2]int
var playerDir [2]int = [2]int{-1, 0}
var visited [][2]int

func main() {
	input = utils.ReadBytesByLine(inputName)
	parse()

	total := part1()
	fmt.Printf("Day 6 Part 1 total: %d\n", total)

	total = part2()
	fmt.Printf("Day 6 Part 2 total: %d\n", total)
}

func part1() int {
	total := 1
	for {
		nextPos := [2]int{playerPos[0] + playerDir[0], playerPos[1] + playerDir[1]}
		if nextPos[0] < 0 || nextPos[0] >= numRows || nextPos[1] < 0 || nextPos[1] >= numCols {
			break
		}

		nextChar := getAt(nextPos[:])

		if nextChar == '#' {
			// Rotation to the right
			turnRight()
			continue
		} else if nextChar == '.' {
			setAt(nextPos[:], 'X')
			visited = append(visited, nextPos)
			total += 1
			// continue
		} else if nextChar == 'X' {
			// continue
		}
		playerPos = nextPos
	}

	return total
}

// This one uses a faster stepping algorithm since we don't need to
// keep track of *all* seen spaces
func part2() int {
	total := 0
	// We only need to check the spaces visited in part 1
	for _, obstPos := range visited {
		obstI := obstPos[0]
		obstJ := obstPos[1]

		playerPos = startPos
		playerDir = [2]int{-1, 0}

		// Insert our new obstacle
		var obstRowIndex int = -1
		var obstColIndex int = -1

		for i, obstCol := range rowObsts[obstI] {
			if obstCol > obstJ {
				obstRowIndex = i
				rowObsts[obstI] = slices.Insert(rowObsts[obstI], i, obstJ)
				break
			}
		}
		if obstRowIndex == -1 {
			obstRowIndex = len(rowObsts[obstI])
			rowObsts[obstI] = append(rowObsts[obstI], obstJ)
		}

		for j, obstRow := range colObsts[obstJ] {
			if obstRow > obstI {
				obstColIndex = j
				colObsts[obstJ] = slices.Insert(colObsts[obstJ], j, obstI)
				break
			}
		}
		if obstColIndex == -1 {
			obstColIndex = len(colObsts[obstJ])
			colObsts[obstJ] = append(colObsts[obstJ], obstI)
		}

		if loops() {
			total += 1
		}

		rowObsts[obstI] = RemoveIndex(rowObsts[obstI], obstRowIndex)
		colObsts[obstJ] = RemoveIndex(colObsts[obstJ], obstColIndex)
	}

	return total
}

func RemoveIndex(s []int, index int) []int {
	return append(s[:index], s[index+1:]...)
}

func loops() bool {
	cache := make([]uint8, numRows*numCols)
	for {
		flag, next := whereCollision()
		if !flag {
			return false
		}

		// Update the position
		if playerDir[0] != 0 {
			playerPos[0] = next
		} else {
			playerPos[1] = next
		}

		turnRight()

		packedDir := packDir()
		if cache[playerPos[0]*numCols+playerPos[1]]&packedDir != 0 {
			return true
		}
		cache[playerPos[0]*numCols+playerPos[1]] |= packedDir
	}
}

func packDir() uint8 {
	switch {
	case playerDir[0] == -1 && playerDir[1] == 0:
		return 1
	case playerDir[0] == 1 && playerDir[1] == 0:
		return 2
	case playerDir[0] == 0 && playerDir[1] == -1:
		return 4
	case playerDir[0] == 0 && playerDir[1] == 1:
		return 8
	default:
		panic("Bad direction")
	}
}

// Returns a flag representing whether a collision occurs, and where
func whereCollision() (bool, int) {
	// X direction
	if playerDir[1] != 0 {
		dir := playerDir[1]

		// Have to start from the correct side to get the closest
		// obstacle in the player direction
		var iter iter.Seq2[int, int]
		if dir > 0 {
			iter = slices.All(rowObsts[playerPos[0]])
		} else {
			iter = slices.Backward(rowObsts[playerPos[0]])
		}

		for _, c := range iter {
			if dir*(c-playerPos[1]) > 0 {
				return true, c - dir
			}
		}
		return false, 0

		// Y Direction
	} else if playerDir[0] != 0 {
		dir := playerDir[0]

		var iter iter.Seq2[int, int]
		if dir > 0 {
			iter = slices.All(colObsts[playerPos[1]])
		} else {
			iter = slices.Backward(colObsts[playerPos[1]])
		}
		for _, r := range iter {
			if dir*(r-playerPos[0]) > 0 {
				return true, r - dir
			}
		}
		return false, 0
	} else {
		return false, 0
	}
}

func turnRight() {
	tempDir1 := playerDir[1]
	playerDir[1] = -playerDir[0]
	playerDir[0] = tempDir1
}

func getAt(pos []int) byte {
	return input[pos[0]][pos[1]]
}

func setAt(pos []int, new byte) {
	input[pos[0]][pos[1]] = new
}

func parse() {
	numRows = len(input)
	numCols = len(input[0])
	rowObsts = make([][]int, numRows)
	colObsts = make([][]int, numCols)

	for row, line := range input {
		for col, char := range line {
			if char == '^' {
				input[row][col] = 'X'
				startPos = [2]int{row, col}
				playerPos = [2]int{row, col}
			} else if char == '#' {
				rowObsts[row] = append(rowObsts[row], col)
				colObsts[col] = append(colObsts[col], row)
			}
		}
	}
}
