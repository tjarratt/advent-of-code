package main

import (
	"io/ioutil"

	"github.com/tjarratt/advent-of-code-2020/day-20/tiles"
)

func main() {
	solver := tiles.NewSolver(input())

	product := 1
	for _, id := range solver.Corners() {
		product *= id
	}

	println(product)

	image, result := solver.Image(12, 12)
	println(image)
	println()
	println(result)
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
