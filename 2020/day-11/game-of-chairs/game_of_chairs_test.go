package game_of_chairs_test

import (
	"fmt"
	"io/ioutil"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-11/game-of-chairs"
)

var _ = Describe("Game of Chairs Simulator", func() {
	It("determines the number of chairs occupied once stable", func() {
		simulator := NewSimulator(fixtureNamed("1.txt"))

		Expect(simulator.OccupiedOnceStable()).To(Equal(37))
	})

	It("handles slightly more picky seat-choosers", func() {
		simulator := NewSimulatorPartTwo(fixtureNamed("1.txt"))

		Expect(simulator.OccupiedOnceStable()).To(Equal(26))
	})
})

func fixtureNamed(file string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", file))
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
