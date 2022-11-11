package main

import (
	"os"
	"strconv"
	"strings"
	"../intcode"
)

func main() {
	part_one()
	part_two()
}

func part_one() {
	input := readInput()
	input[1] = 12
	input[2] = 2

	computer := intcode.NewIntcodeComputer(input)
	computer.RunUntilHalt()

	println("the solution to part one is", computer.Memory()[0])
}

func part_two() {
	desiredValue := 19690720

	for i := 0; i <= 99; i++ {
		for j := 0; j <= 99; j++ {
			input := readInput()
			input[1] = i
			input[2] = j
			computer := intcode.NewIntcodeComputer(input)
			computer.RunUntilHalt()

			if computer.Memory()[0] == desiredValue {
				println("the solution to part two is", 100*i+j)
			}
		}
	}
}

func readInput() []int {
	bytes, err := os.ReadFile("input")
	if err != nil {
		panic(err)
	}

	codes := strings.Split(strings.Trim(string(bytes), "\t \n"), ",")
	input := make([]int, 0, len(codes))
	for _, code := range codes {
		asInt, err := strconv.Atoi(code)
		if err != nil {
			panic(err)
		}
		input = append(input, asInt)
	}

	return input
}
