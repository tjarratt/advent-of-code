package customs_test

import (
	"fmt"
	"io/ioutil"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code-2020/day-06/customs"
)

var _ = Describe("Customs", func() {
	It("sums the unique responses per group", func() {
		counter := CustomsCounter(fixtureNamed("1.txt"))

		Expect(counter.Sum()).To(Equal(11))
	})

	It("sums the shared responses per group", func() {
		counter := IntersectionCustomsCounter(fixtureNamed("1.txt"))

		Expect(counter.Sum()).To(Equal(6))
	})

	It("counts the number of groups", func() {
		counter := CustomsCounter(fixtureNamed("1.txt"))

		Expect(counter.Groups()).To(HaveLen(5))
	})

	It("tracks the unique responses for each group", func() {
		counter := CustomsCounter(fixtureNamed("1.txt"))

		Expect(counter.Groups()[0].Responses()).To(ContainElements("a", "b", "c"))
		Expect(counter.Groups()[1].Responses()).To(ContainElements("a", "b", "c"))
		Expect(counter.Groups()[2].Responses()).To(ContainElements("a", "b", "c"))
		Expect(counter.Groups()[3].Responses()).To(ContainElements("a"))
		Expect(counter.Groups()[4].Responses()).To(ContainElements("b"))
	})
})

func fixtureNamed(name string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", name))
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
