package main

import (
	"io/ioutil"

	"github.com/tjarratt/advent-of-code-2020/day-10/jolted"
)

func main() {
	solver := jolted.ChainedJoltageAdapters(input())

	println(solver.DifferencesOfJolts(1) * solver.DifferencesOfJolts(3))
	println(solver.CountValidCombinations())
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
