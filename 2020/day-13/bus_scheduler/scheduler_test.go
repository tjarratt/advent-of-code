package bus_scheduler_test

import (
	"fmt"
	"io/ioutil"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-13/bus_scheduler"
)

var _ = Describe("Convoluted Bus Schedules", func() {
	It("determines the first bus we could take, based on guesses", func() {
		solver := NewBusScheduleReader(fixtureNamed("1.txt"))

		Expect(solver.FirstBusAvailable()).To(Equal(59))
		Expect(solver.MinutesWaitingForBus()).To(Equal(5))
	})

	It("solves the bus company's context", func() {
		solver := NewBusContestSolver("7,13,x,x,59,x,31,19")
		Expect(solver.ContestSolution()).To(Equal(1068781))

		solver = NewBusContestSolver("67,7,59,61")
		Expect(solver.ContestSolution()).To(Equal(754018))

		solver = NewBusContestSolver("17,x,13,19")
		Expect(solver.ContestSolution()).To(Equal(3417))

		solver = NewBusContestSolver("67,x,7,59,61")
		Expect(solver.ContestSolution()).To(Equal(779210))

		solver = NewBusContestSolver("67,7,x,59,61")
		Expect(solver.ContestSolution()).To(Equal(1261476))

		solver = NewBusContestSolver("1789,37,47,1889")
		Expect(solver.ContestSolution()).To(Equal(1202161486))
	})
})

func fixtureNamed(file string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", file))
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
