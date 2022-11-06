package main

import (
	"os"
	"strconv"
	"strings"
)

func main() {
	part_one()
	part_two()
}

func part_one() {
	fuel_required := 0
	for _, mass := range read_input() {
		fuel_required += fuelFor(mass)
	}

	println("the solution for part one is", fuel_required)
}

func part_two() {
	fuel_required := 0
	for _, mass := range read_input() {
		fuel_required += fuelForIncludingFuel(mass)
	}

	println("the solution for part one is", fuel_required)
}

func read_input() []int {
	bytes, err := os.ReadFile("input")
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(bytes), "\n")
	result := make([]int, 0, len(lines))
	for _, line := range lines {
		if line == "" {
			break
		}

		i, err := strconv.Atoi(line)
		if err != nil {
			panic(err)
		}
		result = append(result, i)
	}

	return result
}

func fuelFor(mass int) int {
	if mass <= 0 {
		return 0
	}

	return mass/3 - 2
}

func fuelForIncludingFuel(mass int) int {
	fuel := fuelFor(mass)
	result := fuel

	for {
		fuel = fuelFor(fuel)
		if fuel <= 0 {
			break
		}

		result += fuel
	}

	return result
}
