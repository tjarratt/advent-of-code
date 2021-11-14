use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashMap;

fn main() {
    part_1();
    part_2();
}

fn part_1() {
    let mut point = Point { x: 0, y: 0 };
    let mut grid: HashMap<Point, bool> = HashMap::new();
    grid.insert(point, true);

    if let Ok(lines) = read_lines("input.txt") {
        for line in lines.flatten() {
            let directions = line.chars();
            for dir in directions {
                match dir {
                    '^' => point.y += 1,
                    'v' => point.y -= 1,
                    '<' => point.x -= 1,
                    '>' => point.x += 1,
                    _ => println!("unexpected direction: {}", dir),
                }

                grid.insert(point, true);
            }          
        }
    }

    println!("part 1 :: {}", grid.keys().len());
}

fn part_2() {
    let mut point = Point { x: 0, y: 0 };
    let mut robo_point = Point { x: 0, y: 0 };
    let mut grid: HashMap<Point, bool> = HashMap::new();
    grid.insert(point, true);

    if let Ok(lines) = read_lines("input.txt") {
        for line in lines.flatten() {
            for directions in line.as_bytes().chunks(2) {
                match directions[0] {
                    b'^' => point.y += 1,
                    b'v' => point.y -= 1,
                    b'<' => point.x -= 1,
                    b'>' => point.x += 1,
                    _ => println!("unexpected direction : {}", directions[0]),
                }

                match directions[1] {
                    b'^' => robo_point.y += 1,
                    b'v' => robo_point.y -= 1,
                    b'<' => robo_point.x -= 1,
                    b'>' => robo_point.x += 1,
                    _ => println!("unexpected direction : {}", directions[1]),
                }
    
                grid.insert(point, true);
                grid.insert(robo_point, true);
            }
        }
    }

    println!("part 2 :: {}", grid.keys().len());
}

fn read_lines(filename: &str) -> io::Result<io::Lines<io::BufReader<File>>> {
    let file = File::open(filename)?;
    let buffer = io::BufReader::new(file);
  
    Ok(buffer.lines())
}

#[derive(Hash, Eq, PartialEq, Clone, Copy)]
struct Point {
    x: i32,
    y: i32,
}
