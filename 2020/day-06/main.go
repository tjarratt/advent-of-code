package main

import (
	"io/ioutil"

	. "github.com/tjarratt/advent-of-code-2020/day-06/customs"
)

func main() {
	println(CustomsCounter(fixtureNamed("input.txt")).Sum())
	println(IntersectionCustomsCounter(fixtureNamed("input.txt")).Sum())
}

func fixtureNamed(name string) string {
	bytes, err := ioutil.ReadFile(name)
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
