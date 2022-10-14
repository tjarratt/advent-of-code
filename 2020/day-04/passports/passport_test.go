package passport_test

import (
	"fmt"
	"io"
	"os"
	"testing"

	"github.com/onsi/gomega"
	. "github.com/onsi/gomega"
	. "github.com/tjarratt/advent-of-code-2020/day-04/passports"
)

func Test_is_valid(t *testing.T) {
	g := gomega.NewGomegaWithT(t)
	validator := PassportValidator(fixtureNamed("1.txt"))

	g.Expect(validator.Valid()).To(HaveLen(2), "expected two valid passports")
	g.Expect(validator.Invalid()).To(HaveLen(2), "expected two invalid passports")

	g.Expect(validator.Valid()[0].EyeColor).To(Equal("gry"))
	g.Expect(validator.Valid()[0].PassportId).To(Equal("860033327"))
	g.Expect(validator.Valid()[0].ExpirationYear).To(Equal("2020"))
	g.Expect(validator.Valid()[0].HairColor).To(Equal("#fffffd"))
	g.Expect(validator.Valid()[0].BirthYear).To(Equal("1937"))
	g.Expect(validator.Valid()[0].IssueYear).To(Equal("2017"))
	g.Expect(validator.Valid()[0].CountryId).To(Equal("147"))
	g.Expect(validator.Valid()[0].Height).To(Equal("183cm"))

	g.Expect(validator.Invalid()[0].EyeColor).To(Equal("amb"))
	g.Expect(validator.Invalid()[0].PassportId).To(Equal("028048884"))
	g.Expect(validator.Invalid()[0].ExpirationYear).To(Equal("2023"))
	g.Expect(validator.Invalid()[0].HairColor).To(Equal("#cfa07d"))
	g.Expect(validator.Invalid()[0].BirthYear).To(Equal("1929"))
	g.Expect(validator.Invalid()[0].IssueYear).To(Equal("2013"))
	g.Expect(validator.Invalid()[0].CountryId).To(Equal("350"))
	g.Expect(validator.Invalid()[0].Height).To(Equal(""))
}

func Test_part_two_valid(t *testing.T) {
	g := gomega.NewGomegaWithT(t)
	validator := StrictPassportValidator(fixtureNamed("part-2-valid.txt"))

	g.Expect(validator.Valid()).To(HaveLen(4))
	g.Expect(validator.Invalid()).To(HaveLen(0))
}

func Test_part_two_invalid(t *testing.T) {
	g := gomega.NewGomegaWithT(t)
	validator := StrictPassportValidator(fixtureNamed("part-2-invalid.txt"))

	g.Expect(validator.Valid()).To(HaveLen(0))
	g.Expect(validator.Invalid()).To(HaveLen(4))
}

func fixtureNamed(fileName string) io.Reader {
	file, err := os.Open(fmt.Sprintf("fixtures/%s", fileName))
	if err != nil {
		panic(err)
	}

	return file
}
