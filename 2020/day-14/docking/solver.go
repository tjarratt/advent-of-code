package docking

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

func NewDockingProgram(input string) solver {
	return solver{input: input}
}

type solver struct {
	input string
}

func (s solver) Solution() int {
	mask := initMask()
	memory := map[int]int{}

	for _, line := range strings.Split(s.input, "\n") {
		if len(line) == 0 {
			continue
		}

		if maskRegex.MatchString(line) {
			mask = updateMask(line)
		} else if memoryRegex.MatchString(line) {
			memory = updateMemory(memory, mask, line)
		} else {
			panic(fmt.Sprintf("unexpected line : '%s'", line))
		}
	}

	result := 0
	for _, value := range memory {
		result += value
	}

	return result
}

func updateMask(line string) []blit {
	pieces := strings.Split(line, " = ")

	newMask := initMask()
	for index, bit := range strings.Split(pieces[1], "") {
		switch bit {
		case "X":
			newMask[len(newMask)-1-index] = x
		case "1":
			newMask[len(newMask)-1-index] = on
		case "0":
			newMask[len(newMask)-1-index] = off
		default:
			panic(fmt.Sprintf("unexpected bit mask '%s'", bit))
		}
	}
	return newMask
}

func updateMemory(memory map[int]int, mask []blit, line string) map[int]int {
	re := regexp.MustCompile("^mem\\[([0-9]+)\\] = ([0-9]+)")
	matches := re.FindStringSubmatch(line)

	addr, _ := strconv.Atoi(matches[1])
	value, _ := strconv.Atoi(matches[2])

	memory[addr] = applyMask(value, mask)
	return memory
}

func applyMask(value int, mask []blit) int {
	result := value

	for i, blit := range mask {
		switch blit {
		case x:
			continue
		case on:
			result = result | (1 << i)
		case off:
			result = result &^ (1 << i)
		}
	}

	return result
}

type blit uint

const (
	x blit = iota
	on
	off
	floating
)

func initMask() []blit {
	mask := make([]blit, 36)
	for i := 0; i < 36; i++ {
		mask[i] = x
	}

	return mask
}

var maskRegex = regexp.MustCompile("^mask")
var memoryRegex = regexp.MustCompile("^mem")
