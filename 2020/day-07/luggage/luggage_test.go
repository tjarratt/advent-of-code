package luggage_test

import (
	"fmt"
	"io/ioutil"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-07/luggage"
)

var _ = Describe("Bag Sorting", func() {
	It("determines which bags can include others", func() {
		sorter := NewBagSorter(fixtureNamed("1.txt"))

		shiny_bag_holders := sorter.BagsWhichCouldContain("shiny gold")

		Expect(shiny_bag_holders).To(HaveLen(4))
		Expect(shiny_bag_holders).To(ContainElements(
			"bright white", "muted yellow",
			"dark orange", "light red",
		))
	})

	It("determines how many bags to stuff inside another", func() {
		sorter := NewBagSorter(fixtureNamed("2.txt"))

		total := sorter.BagsContainedBy("shiny gold")

		Expect(total).To(Equal(126))
	})
})

func fixtureNamed(name string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", name))
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
