package bus_scheduler

import (
	"strconv"
	"strings"
)

func NewBusContestSolver(raw string) solverPartTwo {
	return parsePartTwo(raw)
}

type solverPartTwo struct {
	busses []int
}

func (s solverPartTwo) ContestSolution() int {
	product := 1
	for i := 0; i < len(s.busses); i++ {
		if s.busses[i] == -1 {
			continue
		}
		product = product * s.busses[i]
	}

	result := 0
	for j := 0; j < len(s.busses); j++ {
		if s.busses[j] == -1 {
			continue
		}
		a := s.busses[j] - j
		y := product / s.busses[j]
		z := modular_inverse(y, s.busses[j])

		result += a * y * z
	}

	return result % product
}

func modular_inverse(num, base int) int {
	for i := 1; i <= base; i++ {
		if (num*i)%base == 1 {
			return i
		}
	}

	panic("this should never happen")
}

// pragma mark - private
func parsePartTwo(input string) solverPartTwo {
	busses := []int{}

	for _, bus := range strings.Split(input, ",") {
		if bus == "x" {
			busses = append(busses, -1)
			continue
		}

		bus_time, err := strconv.Atoi(bus)
		if err != nil {
			panic(err)
		}

		busses = append(busses, bus_time)
	}

	return solverPartTwo{busses: busses}
}
