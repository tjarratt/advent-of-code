package main

import (
	"io/ioutil"

	. "github.com/tjarratt/advent-of-code-2020/day-12/navigation"
)

func main() {
	input := input()
	navigator := NavigationAssistant(input)
	waypointNavigator := WaypointNavigationAssistant(input)

	println(navigator.ManhattanDistance())
	println(waypointNavigator.ManhattanDistance())
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
