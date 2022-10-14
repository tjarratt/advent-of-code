package main

import (
	"io/ioutil"

	"github.com/tjarratt/advent-of-code-2020/day-08/handheld"
)

func main() {
	h := handheld.NewHandheld(input())
	h.Run()

	println(h.Accumulator())

	terminator := handheld.NewTerminator(input())
	terminator.Run()

	println(terminator.Accumulator())
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
