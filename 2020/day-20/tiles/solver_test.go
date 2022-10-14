package tiles_test

import (
	"fmt"
	"io/ioutil"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-20/tiles"
)

var _ = Describe("Tiled Image Puzzle Solving", func() {
	It("reads tiles", func() {
		Expect(NewSolver(fixtureNamed("1.txt")).Tiles()).To(HaveLen(9))
	})

	It("finds the corners", func() {
		solver := NewSolver(fixtureNamed("1.txt"))

		Expect(solver.Corners()).To(ContainElements(1171, 2971, 3079, 1951))
	})

	It("is able to solve the image", func() {
		solver := NewSolver(fixtureNamed("1.txt"))

		Expect(solver.Image(3, 3)).To(Equal(fixtureNamed("1_expected.txt")))
	})
})

func fixtureNamed(name string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", name))
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
