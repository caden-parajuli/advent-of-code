module part_1

import arrays
import datatypes
import os

const filename = 'input'

struct QueueMember {
	dist &int
	pos  [2]int
}

fn (a QueueMember) < (b QueueMember) bool {
	return *a.dist < *b.dist
}

fn (a QueueMember) == (b QueueMember) bool {
	return a.dist == b.dist && a.pos == b.pos
}

fn as_index(pos [2]int, line_len int) int {
	return pos[0] + pos[1] * line_len
}

fn (a QueueMember) as_index(line_len int) int {
	return as_index(a.pos, line_len)
}

fn min(arr []int) int {
	return arrays.fold[int, int](arr, arr[0], fn (r int, t int) int {
		if r < t {
			return r
		} else {
			return t
		}
	})
}

pub fn main() {
	lines := (os.read_lines(part_1.filename) or {
		println('input file not found')
		panic(err)
	}).filter(it.len > 2)
	num_lines := lines.len
	line_len := lines[0].len
	mut start_pos := [2]int{}

	for y, line in lines {
		for x, c in line {
			if c == 'S'[0] {
				start_pos[0] = x
				start_pos[1] = y
			}
		}
	}

	// Initialize distances
	mut distances := []int{len: num_lines * line_len, cap: num_lines * line_len, init: max_int}
	distances[start_pos[0] + start_pos[1] * line_len] = 0

	// Dijkstra's algorithm (yes I know it's overkill)

	// Init structures
	mut visited := []bool{len: num_lines * line_len, cap: num_lines * line_len, init: false}
	mut queue := datatypes.MinHeap[QueueMember]{}

	queue.insert(QueueMember{
		dist: &(distances[as_index(start_pos, line_len)])
		pos: start_pos
	})

	// Main Dijkstra loop
	mut current := queue.pop() or { panic(err) }
	for *current.dist != max_int {
		// Update neighbors
		x := current.pos[0]
		y := current.pos[1]
		visited[current.as_index(line_len)] = true

		// Left
		mut index := as_index([x - 1, y]!, line_len)
		mut member := QueueMember{
			dist: &(distances[0])
			pos: [0, 0]!
		}
		if x > 0 && lines[y][x - 1] != '#'[0] && !visited[index] {
			distances[index] = min([distances[current.as_index(line_len)] + 1, distances[index]])
			member = QueueMember{
				dist: &(distances[index])
				pos: [x - 1, y]!
			}
			if member !in queue.data {
				queue.insert(member)
			}
		}
		// Right
		index = as_index([x + 1, y]!, line_len)
		if x + 1 < line_len && lines[y][x + 1] != '#'[0] && !visited[index] {
			distances[index] = min([distances[current.as_index(line_len)] + 1, distances[index]])
			member = QueueMember{
				dist: &(distances[index])
				pos: [x + 1, y]!
			}
			if member !in queue.data {
				queue.insert(member)
			}
		}
		// Above
		index = as_index([x, y - 1]!, line_len)
		if y > 0 && lines[y - 1][x] != '#'[0] && !visited[index] {
			distances[index] = min([distances[current.as_index(line_len)] + 1, distances[index]])
			member = QueueMember{
				dist: &(distances[index])
				pos: [x, y - 1]!
			}
			if member !in queue.data {
				queue.insert(member)
			}
		}
		// Below
		index = as_index([x, y + 1]!, line_len)
		if y + 1 < num_lines && lines[y + 1][x] != '#'[0] && !visited[index] {
			distances[index] = min([distances[current.as_index(line_len)] + 1, distances[index]])
			member = QueueMember{
				dist: &(distances[index])
				pos: [x, y + 1]!
			}
			if member !in queue.data {
				queue.insert(member)
			}
		}

		current = queue.pop() or { break }
	}

	total := get_total(distances)
	println('Part 1 final total: ${total}')
}

fn get_total(distances []int) int {
	mut total := 0
	for dist in distances {
		if dist <= 64 && dist & 1 == 0 {
			total += 1
		}
	}
	return total
}
