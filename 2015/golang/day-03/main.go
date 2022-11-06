package main

import (
	"os"
	"strings"
)

func main() {
	part_one()
	part_two()
}

func part_one() {
	coords := Coordinate{0, 0}

	seen := make(map[Coordinate]int, 0)
	seen[coords] += 1

	directions := read_input()
	for _, dir := range directions {
		switch dir {
		case North:
			coords.Y += 1
		case West:
			coords.X -= 1
		case East:
			coords.X += 1
		case South:
			coords.Y -= 1
		}

		seen[coords] += 1
	}

	println("the solution to part one is", len(seen))
}

func part_two() {
	santa := Coordinate{0, 0}
	robo_santa := Coordinate{0, 0}

	seen := make(map[Coordinate]int, 0)
	seen[santa] += 1
	seen[robo_santa] += 1

	directions := read_input()
	for index, dir := range directions {
		if index % 2 == 0 {
			santa = update_coordinate(santa, dir)
			seen[santa] += 1
		} else {
			robo_santa = update_coordinate(robo_santa, dir)
			seen[robo_santa] += 1
		}

	}

	println("the solution to part two is", len(seen))
}

func update_coordinate(santa Coordinate, dir Dir) Coordinate {
	switch dir {
	case North:
		santa.Y += 1
	case West:
		santa.X -= 1
	case East:
		santa.X += 1
	case South:
		santa.Y -= 1
	}

	return santa
}

func read_input() []Dir {
	bytes, err := os.ReadFile("input")
	if err != nil {
		panic(err)
	}

	pieces := strings.Split(string(bytes), "")
	results := make([]Dir, 0, len(pieces))

	for _, input := range pieces {
		if input == "^" {
			results = append(results, North)
		} else if input == "<" {
			results = append(results, West)
		} else if input == ">" {
			results = append(results, East)
		} else if input == "v" {
			results = append(results, South)
		}
	}
	return results
}

type Coordinate struct {
	X int
	Y int
}

type Dir int

const (
	North Dir = iota
	West      = iota
	East      = iota
	South     = iota
)
