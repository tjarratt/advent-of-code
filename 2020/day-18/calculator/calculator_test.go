package calculator_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	. "github.com/tjarratt/advent-of-code/2020/day-18/calculator"
)

var _ = Describe("Bizarro Math Calculator", func() {
	It("disregards normal operator precedence", func() {
		Expect(Solve("1 + 2 * 3 + 4 * 5 + 6")).To(Equal(71))
	})

	It("handles parentheses with grace", func() {
		Expect(Solve("2 * 3 + (4 * 5)")).To(Equal(26))
		Expect(Solve("5 + (8 * 3 + 9 + 3 * 4 * 3)")).To(Equal(437))
	})

	It("handles nested parentheses with ease", func() {
		Expect(Solve("1 + (2 * 3) + (4 * (5 + 6))")).To(Equal(51))
		Expect(Solve("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")).To(Equal(12240))
		Expect(Solve("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")).To(Equal(13632))
	})
})

var _ = Describe("Advanced Bizarro Math Calculator", func() {
	It("still handles the same case where precedence rules do not change the order", func() {
		Expect(SolveAdvanced("1 + (2 * 3) + (4 * (5 + 6))")).To(Equal(51))
		Expect(SolveAdvanced("2 * 3 + (4 * 5)")).To(Equal(46))
		Expect(SolveAdvanced("5 + (8 * 3 + 9 + 3 * 4 * 3)")).To(Equal(1445))
		Expect(SolveAdvanced("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")).To(Equal(669060))
		Expect(SolveAdvanced("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")).To(Equal(23340))
	})
})
