#![warn(clippy::all, clippy::pedantic)]

use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    part_1();
    part_2();
}

fn part_1() {
    if let Ok(lines) = read_lines("./input.txt") {
        let mut floor = 0;
        for line in lines.flatten() {
            let pieces = line.split("");
            for p in pieces {
                if p == "(" {
                    floor += 1;
                } else if p == ")" {
                    floor -= 1;
                }
            }
        }

        println!("the (part 1) solution is {}", floor);
    }
}

fn part_2() {
    if let Ok(lines) = read_lines("./input.txt") {
        let mut floor = 0;
        let mut index = -1;

        for line in lines.flatten() {
            let pieces = line.split("");
            for p in pieces {
                index += 1;

                if p == "(" {
                    floor += 1;
                }
                if p == ")" {
                    floor -= 1;
                }

                if floor == -1 {
                    println!("The (part 2) solution is {}", index);
                    return;
                }
            }
        }
    }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>> 
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    let buffer = io::BufReader::new(file);

    Ok(buffer.lines())
}

