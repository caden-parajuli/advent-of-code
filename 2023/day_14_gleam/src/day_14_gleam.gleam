import gleam/io
import gleam/result
import part_1
import part_2
import simplifile

const filename: String = "input"

pub fn main() {
  let lines: BitArray =
    simplifile.read_bits(filename)
    |> result.lazy_unwrap(fn() {
      io.println_error("Error reading file.")
      <<>>
    })

  part_1.main(lines)
  part_2.main(lines)
}
