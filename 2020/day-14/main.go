package main

import (
	"io/ioutil"

	"github.com/tjarratt/advent-of-code-2020/day-14/docking"
)

func main() {
	solver := docking.NewDockingProgram(input())

	println(solver.Solution())
	println(solver.V2Solution())
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
