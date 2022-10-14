package main

import (
	"io/ioutil"
	"strings"

	"github.com/tjarratt/advent-of-code-2020/day-16/tickets"
)

func main() {
	solver := tickets.NewFieldScanner(input())

	println(solver.ErrorRate())

	result := 1
	for key, value := range solver.MyTicket() {
		println(key, value)
		if strings.HasPrefix(key, "departure") {
			result *= value
		}
	}

	println(result)
}

func input() string {
	bytes, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
