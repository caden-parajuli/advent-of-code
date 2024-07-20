const INPUT_PATH: &str = "input";

fn decode_line(line: &str) -> u32 {
    let mut first: Option<u32> = None;
    let mut last: Option<u32> = None;
    for char in line.chars() {
        if let c @ '0'..='9' = char {
            let digit = c.to_digit(10).expect("Invalid digit");
            if first.is_none() {
                first = Some(digit);
            }
            last = Some(digit)
        }
    }
    first.unwrap_or(0) * 10 + last.unwrap_or(0)
}

fn main() {
    let mut total = 0;
    for line in common::input_lines(INPUT_PATH) {
        let calibration = decode_line(&line.expect("Could not get line"));
        total += calibration;
    }
    println!("Total: {}", total);
}

#[cfg(test)]
mod tests {
    use crate::decode_line;

    #[test]
    fn decode_basic() {
        assert_eq!(decode_line("pqr3stu8vwx"), 38);
    }
}
