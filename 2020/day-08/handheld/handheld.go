package handheld

import (
	"strconv"
	"strings"
)

type handheld struct {
	accumulator  int
	instructions []instruction
}

type instruction struct {
	operation opcode
	argument  int
}

type opcode int

const (
	acc opcode = iota
	jmp
	nop
)

func NewHandheld(input string) *handheld {
	return &handheld{
		accumulator:  0,
		instructions: parse(input),
	}
}

type terminator struct {
	accumulator  int
	instructions []instruction
}

func NewTerminator(input string) *terminator {
	return &terminator{
		accumulator:  0,
		instructions: parse(input),
	}
}

func (t *terminator) Run() {
	for index, instruction_to_mutate := range t.instructions {
		if instruction_to_mutate.operation == acc {
			continue
		}

		swapped := t.swapOpcode(instruction_to_mutate.operation)
		instructions_copy := t.copyAndSwap(index, swapped)

		handheld := &handheld{accumulator: 0, instructions: instructions_copy}
		if handheld.WouldTerminate() {
			t.accumulator = handheld.Accumulator()
			return
		}
	}
}

func (t *terminator) swapOpcode(op opcode) opcode {
	switch op {
	case jmp:
		return nop
	case nop:
		return jmp
	default:
		panic("This case should never happen")
	}
}

func (t *terminator) copyAndSwap(index int, op opcode) []instruction {
	instructions_copy := make([]instruction, len(t.instructions))
	copy(instructions_copy, t.instructions)

	instructions_copy[index].operation = op

	return instructions_copy
}

func (t *terminator) Accumulator() int {
	return t.accumulator
}

func (h *handheld) Run() {
	seen := map[int]bool{}

	for instruction_pointer := 0; seen[instruction_pointer] == false; {
		seen[instruction_pointer] = true

		instruction := h.instructions[instruction_pointer]

		switch instruction.operation {
		case jmp:
			instruction_pointer += instruction.argument
		case acc:
			h.accumulator += instruction.argument
			instruction_pointer += 1
		case nop:
			instruction_pointer += 1
		}
	}
}

func (h *handheld) WouldTerminate() bool {
	seen := map[int]bool{}

	for instruction_pointer := 0; instruction_pointer < len(h.instructions); {
		if seen[instruction_pointer] {
			return false
		}

		seen[instruction_pointer] = true
		instruction := h.instructions[instruction_pointer]

		switch instruction.operation {
		case jmp:
			instruction_pointer += instruction.argument
		case acc:
			h.accumulator += instruction.argument
			instruction_pointer += 1
		case nop:
			instruction_pointer += 1
		}
	}

	return true
}

func (h *handheld) Accumulator() int {
	return h.accumulator
}

// pragma mark - private
func parse(input string) []instruction {
	instructions := []instruction{}

	for _, line := range strings.Split(input, "\n") {
		if len(line) == 0 {
			continue
		}

		pieces := strings.Split(line, " ")
		op := pieces[0]
		argument, err := strconv.Atoi(pieces[1])
		if err != nil {
			panic(err)
		}

		var opcode opcode
		switch op {
		case "jmp":
			opcode = jmp
		case "acc":
			opcode = acc
		case "nop":
			opcode = nop
		}

		instructions = append(instructions, instruction{
			operation: opcode,
			argument:  argument,
		})
	}

	return instructions
}
