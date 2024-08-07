package part_2

import (
	"os"
	"strconv"
	"strings"
)

const filename = "input"

func check(err error) {
    if err != nil {
        panic(err)
    }
}

type Lens struct {
	label     string
	focal_len int
}

func load_input() string {
	data, err := os.ReadFile(filename)
	check(err)
    return string(data)
}

func Main() {
    input := load_input()

	var boxes [256][]Lens
	steps := strings.Split(input, ",")
	for i := 0; i < len(steps); i++ {
		step := steps[i]

		var label []byte
		var j int
		box := 0
		for j = 0; step[j] != '=' && step[j] != '-'; j++ {
			label = append(label, step[j])
			box += int(step[j])
			box = (box * 17) % 256
		}

		switch step[j] {
		case '=':
			var focal int
			var err error
			if step[len(step)-1] == '\n' {
				focal, err = strconv.Atoi(step[j+1 : len(step)-2])
			} else {
				focal, err = strconv.Atoi(step[j+1:])
			}
			check(err)

			lens := Lens{label: string(label), focal_len: focal}

			var k int
			for k = 0; k < len(boxes[box]); k++ {
				if boxes[box][k].label == string(label) {
					boxes[box][k] = lens
					break
				}
			}
			if k == len(boxes[box]) {
				boxes[box] = append(boxes[box], lens)
			}
		case '-':
			var i int
			for i = 0; i < len(boxes[box]); i++ {
				if boxes[box][i].label == string(label) {
					boxes[box] = append(boxes[box][:i], boxes[box][i+1:]...)
                    break
				}
			}
		}

	}

    total := 0
    for box := 0; box < len(boxes); box++ {
        box_total := 0
        for lens := 0; lens < len(boxes[box]); lens++ {
            box_total += (lens + 1) * boxes[box][lens].focal_len
        }
        total += (box + 1) * box_total 
    }

    print("Part 2 final total: ")
    println(strconv.Itoa(total))
}
