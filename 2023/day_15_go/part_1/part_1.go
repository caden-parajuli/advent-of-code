package part_1

import (
	"os"
)

const filename = "input"

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func Main() {
    input, err := os.ReadFile(filename)
    check(err)
    print("Part 1 final total: ")
    println(int(initialize(input)))
}

func initialize(input []byte) int {
    total := 0
    hash := 0
    for i := 0; i < len(input); i++ {
        switch input[i] {
        case ',', '\n':
            total += hash
            hash = 0
        default:
            hash += int(input[i])
            hash = (hash * 17) % 256
        }
    }
    return total
}
