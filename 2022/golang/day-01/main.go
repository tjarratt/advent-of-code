package main

import (
	"io"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	part_one()
	part_two()
}

func part_one() {
	input := readInput()

	mostCalories := 0
	for _, food := range input {
		currentCalories := 0
		for _, calories := range food {
			currentCalories += calories
		}

		if currentCalories > mostCalories {
			mostCalories = currentCalories
		}
	}

	println(mostCalories)
}

func part_two() {
	input := readInput()

	weightByElves := []int{}
	for _, food := range input {
		calories := 0
		for _, item := range food {
			calories += item
		}

		weightByElves = append(weightByElves, calories)
	}

	sort.Ints(weightByElves)

	total := weightByElves[len(weightByElves)-1] +
		weightByElves[len(weightByElves)-2] +
		weightByElves[len(weightByElves)-3]
	println(total)
}

func readInput() [][]int {
	file, err := os.Open("input")
	if err != nil {
		panic(err)
	}

	contents, err := io.ReadAll(file)
	if err != nil {
		panic(err)
	}

	result := [][]int{}
	for _, lines := range strings.Split(string(contents), "\n\n") {
		weights := []int{}
		for _, line := range strings.Split(lines, "\n") {
			weight, _ := strconv.Atoi(line)
			weights = append(weights, weight)
		}
		result = append(result, weights)
	}

	return result
}
