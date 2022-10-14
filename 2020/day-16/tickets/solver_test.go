package tickets_test

import (
	"fmt"
	"io/ioutil"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-16/tickets"
)

var _ = Describe("TicketScanner", func() {
	It("calculates the error rate of invalid fields", func() {
		subject := NewFieldScanner(fixtureNamed("1.txt"))

		Expect(subject.ErrorRate()).To(Equal(71))
	})

	It("is able to determine which field is which", func() {
		subject := NewFieldScanner(fixtureNamed("2.txt"))

		Expect(subject.MyTicket()["row"]).To(Equal(11))
		Expect(subject.MyTicket()["class"]).To(Equal(12))
		Expect(subject.MyTicket()["seat"]).To(Equal(13))
	})
})

func fixtureNamed(file string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", file))
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
