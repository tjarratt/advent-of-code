package jolted_test

import (
	"fmt"
	"io/ioutil"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code/2020/day-10/jolted"
)

var _ = Describe("Joltage adapters", func() {
	It("determines the number of 1-jolt and 3-jolt differences in a chain of adapters", func() {
		solver := ChainedJoltageAdapters(fixtureNamed("1.txt"))

		Expect(solver.DifferencesOfJolts(1)).To(Equal(22))
		Expect(solver.DifferencesOfJolts(3)).To(Equal(10))
	})

	It("counts valid combinations of adapters", func() {
		solver := ChainedJoltageAdapters(fixtureNamed("small.txt"))

		Expect(solver.CountValidCombinations()).To(Equal(8))
	})

	It("determines valid combinations of LARGE chains of adapters", func() {
		solver := ChainedJoltageAdapters(fixtureNamed("1.txt"))

		Expect(solver.CountValidCombinations()).To(Equal(19208))
	})

	It("calculates the combinations of various 1-chains", func() {
		Expect(ChainedJoltageAdapters("1").CountValidCombinations()).To(Equal(1))
		Expect(ChainedJoltageAdapters("1\n2").CountValidCombinations()).To(Equal(2))
		Expect(ChainedJoltageAdapters("1\n2\n3").CountValidCombinations()).To(Equal(4))
		Expect(ChainedJoltageAdapters("1\n2\n3\n4").CountValidCombinations()).To(Equal(7))
		Expect(ChainedJoltageAdapters("1\n2\n3\n4\n5").CountValidCombinations()).To(Equal(13))
		Expect(ChainedJoltageAdapters("1\n2\n3\n4\n5\n6").CountValidCombinations()).To(Equal(24))
		Expect(ChainedJoltageAdapters("1\n2\n3\n4\n5\n6\n7").CountValidCombinations()).To(Equal(44))
	})
})

func fixtureNamed(file string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", file))
	if err != nil {
		panic(err)
	}

	return string(bytes)
}
