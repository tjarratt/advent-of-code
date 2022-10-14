package main

import (
	"os"

	. "github.com/tjarratt/advent-of-code-2020/day-04/passports"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}

	validator := PassportValidator(file)
	println(len(validator.Valid()))

	file, _ = os.Open("input.txt")
	validator = StrictPassportValidator(file)
	println(len(validator.Valid()))
}
