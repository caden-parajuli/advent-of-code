use std::{fs::File, io::{self, BufReader}};
use std::io::BufRead;

pub fn input_lines(path: &str) -> io::Lines<io::BufReader<File>> {
    let file = File::open(path).expect("Could not read input");
    let buf_reader = BufReader::new(file);
    buf_reader.lines()
}
