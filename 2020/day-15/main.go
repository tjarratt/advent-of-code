package main

import . "github.com/tjarratt/advent-of-code/2020/day-15/counting"

func main() {
	solver := NewCountingSolver("6,4,12,1,20,0,16")

	println(solver.NumberSpokenAtTurn(2020))
	println(solver.NumberSpokenAtTurn(30000000))
}
