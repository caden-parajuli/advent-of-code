import gleam/int
import gleam/io
import gleam/list

const newline = 10

pub fn main(lines: BitArray) {
  let line_len = get_line_len(lines, 0)
  // Pattern is a square
  let stride = line_len + 1

  let cols = list.range(0, line_len - 1)
  let total =
    cols
    |> list.map(fn(line) { get_line_total_wrapped(lines, line, stride) })
    |> list.fold(0, int.add)

  io.print("Part 1 final total: ")
  io.println(int.to_string(total))
}

fn get_line_len(lines: BitArray, pos: Int) {
  let bytes_before = pos * 8
  let assert <<_:size(bytes_before), next:size(8), _:bytes>> = lines
  case next {
    c if c == newline -> pos
    _ -> get_line_len(lines, pos + 1)
  }
}

fn get_line_total_wrapped(lines: BitArray, line_index: Int, stride: Int) {
  get_line_total(lines, line_index, stride, stride - 2, 0)
}

fn get_line_total(
  lines: BitArray,
  line_index: Int,
  stride: Int,
  ver_index: Int,
  round_below: Int,
) -> Int {
  let num_lines = stride - 1
  let bytes_before = 8 * { line_index + ver_index * stride }
  case ver_index {
    // Top line
    0 -> {
      let #(final_round, top_index) = case lines {
        <<_:size(bytes_before), "O":utf8, _:bytes>> -> #(round_below + 1, 0)
        <<_:size(bytes_before), "#":utf8, _:bytes>> -> #(round_below, 1)
        <<_:size(bytes_before), ".":utf8, _:bytes>> -> #(round_below, 0)
        _ -> panic as "Bad char at top of get_line_total"
      }
      let round_scores = case final_round {
        0 -> []
        _ ->
          list.range(
            num_lines - { top_index },
            num_lines - { top_index + final_round - 1 },
          )
      }
      let total = list.fold(round_scores, 0, int.add)
      total
    }
    _ ->
      case lines {
        <<_:size(bytes_before), "O":utf8, _:bytes>> -> {
          // io.debug(ver_index)
          get_line_total(
            lines,
            line_index,
            stride,
            ver_index - 1,
            round_below + 1,
          )
        }
        <<_:size(bytes_before), "#":utf8, _:bytes>> -> {
          let round_scores = case round_below {
            0 -> []
            _ ->
              list.range(
                num_lines - ver_index - 1,
                num_lines - ver_index - round_below,
              )
          }
          let total = list.fold(round_scores, 0, int.add)
          total + get_line_total(lines, line_index, stride, ver_index - 1, 0)
        }
        <<_:size(bytes_before), ".":utf8, _:bytes>> ->
          get_line_total(lines, line_index, stride, ver_index - 1, round_below)
        <<_:size(bytes_before), "\n":utf8, _:bytes>> ->
          panic as "Called get_line_total on newline!"
        _ -> panic as "Bad character in get_line_total!"
      }
  }
}
