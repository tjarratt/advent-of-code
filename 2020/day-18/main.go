package main

import (
	"io/ioutil"
	"strings"

	"github.com/tjarratt/advent-of-code-2020/day-18/calculator"
)

func main() {
	part1 := 0
	part2 := 0

	for _, line := range strings.Split(input(), "\n") {
		if len(line) == 0 {
			continue
		}

		part1 += calculator.Solve(line)
		part2 += calculator.SolveAdvanced(line)
	}

	println(part1)
	println(part2)
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
