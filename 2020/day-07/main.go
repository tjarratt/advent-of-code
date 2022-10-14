package main

import (
	"io/ioutil"

	"github.com/tjarratt/advent-of-code/2020/day-07/luggage"
)

func main() {
	input, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	sorter := luggage.NewBagSorter(string(input))
	println(len(sorter.BagsWhichCouldContain("shiny gold")))
	println(sorter.BagsContainedBy("shiny gold"))
}
