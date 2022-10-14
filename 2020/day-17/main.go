package main

import (
	"io/ioutil"

	. "github.com/tjarratt/advent-of-code-2020/day-17/conway_cubes"
)

func main() {
	part1()
	part2()
}

func part1() {
	solver := NewCubeSimulationSolver(input())

	for i := 0; i < 6; i++ {
		solver.Run()
	}

	println(solver.ActiveCubes())
}

func part2() {
	solver := NewHyperCubeSimulationSolver(input())

	for i := 0; i < 6; i++ {
		solver.Run()
	}

	println(solver.ActiveCubes())
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
