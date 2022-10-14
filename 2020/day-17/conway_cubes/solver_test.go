package conway_cubes_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-17/conway_cubes"
)

var _ = Describe("Conway's Cube Game of Life Variant", func() {
	It("can do something simple to start with", func() {
		subject := NewCubeSimulationSolver(`
.#.
..#
###`)

		Expect(subject.SliceAtZIndex(0)).To(Equal(
			`
.#.
..#
###
`))
	})

	It("can simulate a round of conway's energy cubes", func() {
		subject := NewCubeSimulationSolver(`
.#.
..#
###`)
		subject.Run()

		Expect(subject.SliceAtZIndex(-1)).To(Equal(`
.....
.....
.#...
...#.
..#..
`))

		Expect(subject.SliceAtZIndex(0)).To(Equal(`
.....
.....
.#.#.
..##.
..#..
`))
		Expect(subject.SliceAtZIndex(1)).To(Equal(`
.....
.....
.#...
...#.
..#..
`))
	})
})
