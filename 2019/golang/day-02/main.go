package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	part_one()
	part_two()
}

func part_one() {
	input := read_input()
	input[1] = 12
	input[2] = 2
	computer := NewIntcodeComputer(input)
	computer.RunUntilHalt()
	println("the solution to part one is", computer.Memory()[0])
}

func part_two() {

	desired_value := 19690720

	for i := 0; i <= 99; i++ {
		for j := 0; j <= 99; j++ {
			input := read_input()
			input[1] = i
			input[2] = j
			computer := NewIntcodeComputer(input)
			computer.RunUntilHalt()

			if computer.Memory()[0] == desired_value {
				println("the solution to part two is", 100 * i + j)
			}
		}
	}
}

func read_input() []int {
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

type IntcodeComputer interface {
	Memory() []int

	RunUntilHalt()
}

func NewIntcodeComputer(input []int) IntcodeComputer {
	return &intcodeComputer{memory: input}
}

type intcodeComputer struct {
	memory []int
}

func (computer *intcodeComputer) Memory() []int {
	return computer.memory
}

func (computer *intcodeComputer) RunUntilHalt() {
	instructionPointer := 0

	for {
		instruction := instructionFor(computer.memory[instructionPointer])
		switch instruction {
		case Add:
			destination := computer.memory[instructionPointer+3]
			computer.memory[destination] = computer.valueAtAddress(instructionPointer+1) + computer.valueAtAddress(instructionPointer+2)
			instructionPointer += 4
		case Multiply:
			destination := computer.memory[instructionPointer+3]
			computer.memory[destination] = computer.valueAtAddress(instructionPointer+1) * computer.valueAtAddress(instructionPointer+2)
			instructionPointer += 4
		case Halt:
			return
		}
	}
}

func (computer intcodeComputer) valueAtAddress(address int) int {
	return computer.memory[computer.memory[address]]
}

func instructionFor(value int) OpCode {
	switch value {
	case 1:
		return Add
	case 2:
		return Multiply
	case 99:
		return Halt
	default:
		panic(fmt.Sprintf("Unexpected opcode %d", value))
	}
}

type OpCode int

const (
	Add      OpCode = iota
	Multiply OpCode = iota
	Halt     OpCode = iota
)
