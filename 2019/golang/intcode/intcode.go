package intcode

import "fmt"

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
