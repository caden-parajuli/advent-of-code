use std::collections::HashMap;

const INPUT_PATH: &str = "input";
const HASHMAP_INIT: [(&str, u32); 9] = [
    ("one", 1),
    ("two", 2),
    ("three", 3),
    ("four", 4),
    ("five", 5),
    ("six", 6),
    ("seven", 7),
    ("eight", 8),
    ("nine", 9),
];

/// This solution is fairly inefficient, but not terribly so
fn decode_line(line: &str, digit_map: &HashMap<&str, u32>) -> u32 {
    let mut first: Option<u32> = None;
    let mut last: Option<u32> = None;
    for (i, char) in line.chars().enumerate() {
        if let c @ '0'..='9' = char {
            let digit = c.to_digit(10).expect("Invalid digit");
            if first.is_none() {
                first = Some(digit);
            }
            last = Some(digit)
        } else {
            for (key, value) in digit_map.iter() {
                if i + key.len() <= line.len() {
                    let possible_num = &line[i..i + key.len()];
                    if possible_num == *key {
                        // Set first/last variables
                        if first.is_none() {
                            first = Some(*value);
                        }
                        last = Some(*value);
                    }
                }
            }
        }
    }
    first.unwrap_or(0) * 10 + last.unwrap_or(0)
}

fn main() {
    let digit_map = HashMap::from(HASHMAP_INIT);
    let mut total = 0;
    for line in common::input_lines(INPUT_PATH) {
        let calibration = decode_line(&line.expect("Could not get line"), &digit_map);
        total += calibration;
    }
    println!("Total: {}", total);
}

#[cfg(test)]
mod tests {
    use crate::{decode_line, HASHMAP_INIT};
    use std::collections::HashMap;

    #[test]
    fn decode_basic() {
        let digit_map = HashMap::from(HASHMAP_INIT);
        assert_eq!(decode_line("pqr3stu8vwx", &digit_map), 38);
    }

    #[test]
    fn decode_letters() {
        let digit_map = HashMap::from(HASHMAP_INIT);
        assert_eq!(decode_line("jtwone8five", &digit_map), 25);
    }
}
