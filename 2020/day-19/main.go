package main

import (
	"io/ioutil"

	"github.com/tjarratt/advent-of-code-2020/day-19/messages"
)

func main() {
	input := input()
	solver := messages.NewSolver(input)
	advanced_solver := messages.NewAdvancedSolver(input)

	println(solver.UncorruptedMessages())
	println(advanced_solver.UncorruptedMessages())
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}
	return string(bytes)
}
