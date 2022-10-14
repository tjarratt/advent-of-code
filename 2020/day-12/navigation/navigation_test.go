package navigation_test

import (
	"fmt"
	"io/ioutil"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-12/navigation"
)

var _ = Describe("Navigating a boat", func() {
	It("calculates the manhattan distance of its destination", func() {
		solver := NavigationAssistant(fixtureNamed("1.txt"))

		Expect(solver.ManhattanDistance()).To(Equal(25))
	})

	It("calculates the distance given a waypoint", func() {
		solver := WaypointNavigationAssistant(fixtureNamed("1.txt"))

		Expect(solver.ManhattanDistance()).To(Equal(286))
	})
})

func fixtureNamed(file string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", file))
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
