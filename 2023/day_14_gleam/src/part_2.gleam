import gleam/bytes_builder.{type BytesBuilder}
import gleam/int
import gleam/io
import gleam/option.{type Option}
import gleam/string

const newline = 10

const num_cycles = 1_000_000_000

pub fn main(lines: BitArray) {
  let line_len = get_line_len(lines, 0)
  let stride = line_len + 1
  // Rotate once for easier indexing
  let lines = lines |> rotate(stride)

  let cycles_done = cycles(lines, stride, 0, [])
  io.print("Part 2 final total: ")
  cycles_done |> score |> int.to_string |> io.println
}

/// Gets the length of the first line of the input, which
/// is also the length of every other line and the number of lines.
fn get_line_len(lines: BitArray, pos: Int) {
  let bytes_before = pos * 8
  let assert <<_:size(bytes_before), next:size(8), _:bytes>> = lines
  case next {
    c if c == newline -> pos
    _ -> get_line_len(lines, pos + 1)
  }
}

/// Recursively cycles the input until it is done, using the cache to detect periodicity
fn cycles(
  lines: BitArray,
  stride: Int,
  cycles_done: Int,
  cache: List(#(Int, BitArray)),
) -> BitArray {
  case num_cycles - cycles_done {
    0 -> lines
    n if n < 0 -> {
      io.debug(n)
      panic as "Negative number left"
    }
    _ ->
      case search(lines, cache) {
        option.None ->
          lines
          |> cycle(stride)
          |> cycles(stride, cycles_done + 1, [#(cycles_done, lines), ..cache])
        option.Some(i) -> {
          let period = cycles_done - i
          let remaining = { num_cycles - cycles_done } % period
          let equiv_done = num_cycles - remaining
          lines |> cycle(stride) |> cycles(stride, equiv_done + 1, [])
        }
      }
  }
}

/// Recursively looks up the input in the cache, returning its index.
fn search(input: BitArray, cache: List(#(Int, BitArray))) -> Option(Int) {
  case cache {
    [] -> option.None
    [#(i, array), ..] if array == input -> option.Some(i)
    [_, ..rest] -> search(input, rest)
  }
}

/// Cycles the input once
fn cycle(lines: BitArray, stride: Int) -> BitArray {
  lines
  // Tilt "North"
  |> tilt_right(stride)
  |> rotate(stride)
  // Tilt "West"
  |> tilt_right(stride)
  |> rotate(stride)
  // Tilt "South"
  |> tilt_right(stride)
  |> rotate(stride)
  // Tilt "East"
  |> tilt_right(stride)
  |> rotate(stride)
}

/// Rotates the input once clockwise
fn rotate(lines: BitArray, stride: Int) -> BitArray {
  let width = stride - 1
  let bytes =
    rotate_aux(lines, bytes_builder.new(), stride, width, width - 1, 0)
  bytes_builder.to_bit_array(bytes)
}

fn rotate_aux(
  lines: BitArray,
  bytes: BytesBuilder,
  stride: Int,
  width: Int,
  row: Int,
  col: Int,
) -> BytesBuilder {
  case row {
    r if r >= 0 -> {
      case col {
        c if c < width -> {
          let bits_before = 8 * { row * stride + col }
          case lines {
            <<_:size(bits_before), char:size(8), _:bytes>> -> {
              let new_bytes = bytes_builder.append(bytes, <<char:size(8)>>)
              rotate_aux(lines, new_bytes, stride, width, row - 1, col)
            }
            _ -> {
              io.debug(bits_before)
              panic as "Bad case in lines"
            }
          }
        }
        _ -> bytes
      }
    }
    _ -> {
      let new_bytes = bytes_builder.append_string(bytes, "\n")
      rotate_aux(lines, new_bytes, stride, width, width - 1, col + 1)
    }
  }
}

fn tilt_right(lines: BitArray, stride: Int) -> BitArray {
  tilt_right_aux(lines, stride, bytes_builder.new(), 0)
  |> bytes_builder.to_bit_array()
}

fn tilt_right_aux(
  lines: BitArray,
  stride: Int,
  bytes: BytesBuilder,
  line: Int,
) -> BytesBuilder {
  let width = stride - 1
  case line {
    l if l < width ->
      tilt_right_aux(
        lines,
        stride,
        tilt_line_right(lines, stride, bytes, line, 0, 0, 0),
        line + 1,
      )
    _ -> bytes
  }
}

fn tilt_line_right(
  lines: BitArray,
  stride: Int,
  bytes: BytesBuilder,
  line: Int,
  col: Int,
  rounds_before: Int,
  dots_before: Int,
) -> BytesBuilder {
  let width = stride - 1
  let bits_before = 8 * { line * stride + col }
  case col {
    c if c >= width ->
      bytes
      |> bytes_builder.append_string(string.repeat(".", dots_before))
      |> bytes_builder.append_string(string.repeat("O", rounds_before))
      |> bytes_builder.append_string("\n")
    _ -> {
      case lines {
        <<_:size(bits_before), "#":utf8, _:bytes>> -> {
          let new_bytes =
            bytes
            |> bytes_builder.append_string(string.repeat(".", dots_before))
            |> bytes_builder.append_string(string.repeat("O", rounds_before))
            |> bytes_builder.append_string("#")
          tilt_line_right(lines, stride, new_bytes, line, col + 1, 0, 0)
        }
        <<_:size(bits_before), "O":utf8, _:bytes>> -> {
          tilt_line_right(
            lines,
            stride,
            bytes,
            line,
            col + 1,
            rounds_before + 1,
            dots_before,
          )
        }
        <<_:size(bits_before), ".":utf8, _:bytes>> -> {
          tilt_line_right(
            lines,
            stride,
            bytes,
            line,
            col + 1,
            rounds_before,
            dots_before + 1,
          )
        }
        _ -> panic as "Bad case in tilt_line_right!"
      }
    }
  }
}

fn score(lines: BitArray) {
  score_aux(lines, 1)
}

fn score_aux(lines: BitArray, since_last_newline: Int) {
  case lines {
    <<"O":utf8, rest:bits>> ->
      since_last_newline + score_aux(rest, since_last_newline + 1)
    <<".":utf8, rest:bits>> -> score_aux(rest, since_last_newline + 1)
    <<"#":utf8, rest:bits>> -> score_aux(rest, since_last_newline + 1)
    <<"\n":utf8, rest:bits>> -> score_aux(rest, 1)
    _ -> 0
  }
}
