module part_2

import arrays
import datatypes
import os

const filename = 'input'
const max_distance = 26501365

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
	lines := (os.read_lines(part_2.filename) or {
		println('input file not found')
		panic(err)
	}).filter(it.len > 2)
	num_lines := lines.len
	line_len := lines[0].len
	assert num_lines == line_len
	assert num_lines & 1 == 1
	mut start_pos := [2]int{}

	// Get start position
	for y, line in lines {
		for x, c in line {
			if c == 'S'[0] {
				start_pos[0] = x
				start_pos[1] = y
			}
		}
	}

	offset := part_2.max_distance % line_len
	constant := dijkstra(lines, line_len, start_pos, offset, 1)
	at_one := dijkstra(lines, line_len, start_pos, offset + line_len, 3)
	at_two := dijkstra(lines, line_len, start_pos, offset + 2 * line_len, 5)
	// Interpolation
	linear := i64(4 * at_one - at_two - 3 * constant) / 2
	quadratic := i64(at_two - 2 * linear - constant) / 4

	eval_at := i64(part_2.max_distance - offset) / line_len

	total := eval_at * (eval_at * quadratic + linear) + constant

	println('Part 2 final total: ${total}')
}

fn dijkstra(lines []string, line_len int, regular_start_pos [2]int, max_dist int, num_cells int) int {
	real_line_end := line_len * num_cells
	start_pos := [regular_start_pos[0] + line_len * (num_cells - 1) / 2,
		regular_start_pos[1] + line_len * (num_cells - 1) / 2]!
	// Init structures
	mut distances := []int{len: real_line_end * real_line_end, cap: real_line_end * real_line_end, init: max_int}
	distances[start_pos[0] + start_pos[1] * real_line_end] = 0
	mut visited := []bool{len: real_line_end * real_line_end, cap: real_line_end * real_line_end, init: false}
	mut queue := datatypes.MinHeap[QueueMember]{}

	queue.insert(QueueMember{
		dist: &(distances[as_index(start_pos, real_line_end)])
		pos: start_pos
	})

	// Main Dijkstra loop
	mut current := queue.pop() or { panic(err) }
	for *current.dist != max_int {
		// Update neighbors
		x := current.pos[0]
		y := current.pos[1]
		visited[current.as_index(real_line_end)] = true

		// Left
		mut index := as_index([x - 1, y]!, real_line_end)
		mut member := QueueMember{
			dist: &(distances[0])
			pos: [0, 0]!
		}
		if x > 0 && lines[y % line_len][(x - 1) % line_len] != '#'[0] && !visited[index] {
			distances[index] = min([distances[current.as_index(real_line_end)] + 1, distances[index]])
			member = QueueMember{
				dist: &(distances[index])
				pos: [x - 1, y]!
			}
			if member !in queue.data {
				queue.insert(member)
			}
		}
		// Right
		index = as_index([x + 1, y]!, real_line_end)
		if x + 1 < real_line_end && lines[y % line_len][(x + 1) % line_len] != '#'[0]
			&& !visited[index] {
			distances[index] = min([distances[current.as_index(real_line_end)] + 1, distances[index]])
			member = QueueMember{
				dist: &(distances[index])
				pos: [x + 1, y]!
			}
			if member !in queue.data {
				queue.insert(member)
			}
		}
		// Above
		index = as_index([x, y - 1]!, real_line_end)
		if y > 0 && lines[(y - 1) % line_len][x % line_len] != '#'[0] && !visited[index] {
			distances[index] = min([distances[current.as_index(real_line_end)] + 1, distances[index]])
			member = QueueMember{
				dist: &(distances[index])
				pos: [x, y - 1]!
			}
			if member !in queue.data {
				queue.insert(member)
			}
		}
		// Below
		index = as_index([x, y + 1]!, real_line_end)
		if y + 1 < real_line_end && lines[(y + 1) % line_len][x % line_len] != '#'[0]
			&& !visited[index] {
			distances[index] = min([distances[current.as_index(real_line_end)] + 1, distances[index]])
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

	mut total := 0
	for dist in distances {
		if dist <= max_dist && dist & 1 == max_dist & 1 {
			total += 1
		}
	}
	return total
}
