use std::fs::File;
use std::io::{self, BufRead};

fn main() {
    part_1();
    part_2();
}

fn part_1() {
    if let Ok(lines) = read_lines("input.txt") {
        let mut total = 0;

        for line in lines.flatten() {
            let pieces: Vec<i32> = line.split("x")
                                       .map(|s| s.parse().unwrap())
                                       .collect();
            let intermed = [pieces[0] * pieces[1], pieces[0] * pieces[2], pieces[1] * pieces[2]];
            let min = intermed.iter().min().unwrap();
            let result = [2 * intermed[0], 2 * intermed[1], 2 * intermed[2], *min];

            let sum: i32 = result.iter().sum();
            total = total + sum;
        }

        println!("{}", total);
    }
}

fn part_2() {
    if let Ok(lines) = read_lines("input.txt") {
        let mut total = 0;

        for line in lines.flatten() {
            let mut pieces: Vec<i32> = line.split("x")
                                       .map(|s| s.parse().unwrap())
                                       .collect();
            
            pieces.sort();

            let toto = [2 * pieces[0], 2 * pieces[1], pieces[0] * pieces[1] * pieces[2]];
            let sum: i32 = toto.iter().sum();
            total = total + sum;
        }

        println!("{}", total);
    }
}

fn read_lines(filename: &str) -> io::Result<io::Lines<io::BufReader<File>>> {
    let file = File::open(filename)?;
    let buffer = io::BufReader::new(file);
    
    Ok(buffer.lines())
}

