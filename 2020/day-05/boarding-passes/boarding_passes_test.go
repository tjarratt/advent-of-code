package boarding_passes_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	. "github.com/tjarratt/advent-of-code-2020/day-05/boarding-passes"
)

var _ = Describe("BoardingPasses", func() {
	passes := []string{
		"BFFFBBFRRR",
		"FFFBBBFRRR",
		"BBFFBBFRLL",
	}

	It("can determine the correct row and column", func() {
		Expect(NewBoardingPass(passes[0]).Location()).To(Equal(Seat{Row: 70, Column: 7}))
		Expect(NewBoardingPass(passes[1]).Location()).To(Equal(Seat{Row: 14, Column: 7}))
		Expect(NewBoardingPass(passes[2]).Location()).To(Equal(Seat{Row: 102, Column: 4}))
	})

	It("can determine the seat id", func() {
		Expect(NewBoardingPass(passes[0]).SeatId()).To(Equal(567))
		Expect(NewBoardingPass(passes[1]).SeatId()).To(Equal(119))
		Expect(NewBoardingPass(passes[2]).SeatId()).To(Equal(820))
	})

	It("Knows when it is empty", func() {
		var taken = NewBoardingPass(passes[0])
		var empty BoardingPass

		Expect(taken.IsEmpty()).To(BeFalse())
		Expect(empty.IsEmpty()).To(BeTrue())
	})
})
