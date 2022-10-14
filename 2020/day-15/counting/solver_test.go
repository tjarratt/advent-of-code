package counting_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-15/counting"
)

var _ = Describe("The Counting Problem Solver", func() {
	It("keeps track of numbers spoken at various turns", func() {
		subject := NewCountingSolver("0,3,6")

		Expect(subject.NumberSpokenAtTurn(1)).To(Equal(0))
		Expect(subject.NumberSpokenAtTurn(2)).To(Equal(3))
		Expect(subject.NumberSpokenAtTurn(3)).To(Equal(6))
		Expect(subject.NumberSpokenAtTurn(10)).To(Equal(0))
	})

	It("says either 0 or the number of turns since a number was last spoken", func() {
		subject := NewCountingSolver("0,3,6")

		Expect(subject.Solve()).To(Equal(0))
		Expect(subject.Solve()).To(Equal(3))
		Expect(subject.Solve()).To(Equal(3))
		Expect(subject.Solve()).To(Equal(1))
		Expect(subject.Solve()).To(Equal(0))
		Expect(subject.Solve()).To(Equal(4))
		Expect(subject.Solve()).To(Equal(0))
	})
})
