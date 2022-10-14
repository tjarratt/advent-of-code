package main

import (
	"io/ioutil"

	. "github.com/tjarratt/advent-of-code-2020/day-03/toboggan"
)

func main() {
	fixture, err := ioutil.ReadFile("input-1.txt")
	if err != nil {
		panic(err)
	}

	grid := NewGrid(fixture)

	// pragma mark - part 1
	println(grid.CountTrees(Trajectory{Right: 3, Down: 1}))

	// pragma mark - part 2
	input := []Trajectory{
		{Right: 1, Down: 1},
		{Right: 3, Down: 1},
		{Right: 5, Down: 1},
		{Right: 7, Down: 1},
		{Right: 1, Down: 2},
	}

	result := 1
	for _, trajectory := range input {
		result = result * grid.CountTrees(trajectory)
	}

	println(result)
}
