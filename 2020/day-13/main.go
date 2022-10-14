package main

import (
	"io/ioutil"
	"strings"

	. "github.com/tjarratt/advent-of-code-2020/day-13/bus_scheduler"
)

func main() {
	solver := NewBusScheduleReader(input())

	println(solver.FirstBusAvailable() * solver.MinutesWaitingForBus())

	println(NewBusContestSolver(strings.Split(input(), "\n")[1]).ContestSolution())
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
