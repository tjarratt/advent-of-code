package allergens_test

import (
  "io/ioutil"
  "fmt"

  . "github.com/onsi/ginkgo"
  . "github.com/onsi/gomega"
  . "github.com/tjarratt/advent-of-code-2020/day-21/allergens"
)

var _ = Describe("Allergens", func() {
  It("is a load bearing testing", func() {
    subject := NewSolver(fixtureNamed("1.txt"))

    Expect(subject.SafeIngredients()).To(ContainElements("kfcds", "nhms", "sbzzf", "trh"))
  })
})

func fixtureNamed(filename string) string {
  bytes, err := ioutil.ReadFile(fmt.Sprintf("fixtures/%s", filename))
  if err != nil { panic(err) }

  return string(bytes)
}

