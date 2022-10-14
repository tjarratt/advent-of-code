package bus_scheduler

import (
	"sort"
	"strconv"
	"strings"
)

func NewBusScheduleReader(raw string) solver {
	return parse(raw)
}

type solver struct {
	time_to_leave int
	busses        []int
}

func (s solver) FirstBusAvailable() int {
	for multiplier := 1; multiplier < 10000; multiplier++ {
		for _, bus := range s.busses {
			if bus*multiplier-s.time_to_leave >= 0 {
				return bus
			}
		}
	}
	return -1
}

func (s solver) MinutesWaitingForBus() int {
	for multiplier := 1; multiplier < 10000; multiplier++ {
		for _, bus := range s.busses {
			if bus*multiplier-s.time_to_leave >= 0 {
				return bus*multiplier - s.time_to_leave
			}
		}
	}
	return -1
}

// pragma mark - private
func parse(input string) solver {
	lines := strings.Split(input, "\n")
	if len(lines) < 2 {
		panic("not enough input")
	}

	departure, err := strconv.Atoi(lines[0])
	if err != nil {
		panic(err)
	}

	busses := []int{}

	for _, line := range lines[1:] {
		for _, bus := range strings.Split(line, ",") {
			if bus == "x" || len(bus) == 0 {
				continue
			}

			bus_time, err := strconv.Atoi(bus)
			if err != nil {
				panic(err)
			}

			busses = append(busses, bus_time)
		}
	}

	sort.Slice(busses, func(i, j int) bool {
		return busses[i] < busses[j]
	})

	return solver{time_to_leave: departure, busses: busses}
}
