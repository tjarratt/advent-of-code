package main

import (
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"

	. "github.com/tjarratt/advent-of-code-2020/day-02/rules"
)

func main() {
	input := readInput()

	first_valid := 0
	second_valid := 0
	for _, toCheck := range input {
		if IsValid(toCheck.Password, toCheck.Rule) {
			first_valid += 1
		}

		if IsValidTobogganPassword(toCheck.Password, toCheck.Rule) {
			second_valid += 1
		}
	}

	println(first_valid)
	println(second_valid)
}

// pragma mark - private
func readInput() []CheckedPassword {
	stuff, err := ioutil.ReadFile("input-1.txt")
	if err != nil {
		panic(err)
	}

	contents := string(stuff)
	lines := strings.Split(contents, "\n")

	// 1-3 a: abcdefg
	re := regexp.MustCompile("([0-9]+)-([0-9]+) ([a-zA-Z]): ([a-zA-Z]+)")
	input := []CheckedPassword{}
	for i := 0; i < len(lines); i++ {
		matches := re.FindStringSubmatch(lines[i])

		min, err := strconv.Atoi(matches[1])
		if err != nil {
			panic(err)
		}
		max, err := strconv.Atoi(matches[2])
		if err != nil {
			panic(err)
		}
		rule := Rule{Letter: matches[3], Maximum: max, Minimum: min}
		input = append(input, CheckedPassword{Password: matches[4], Rule: rule})
	}

	return input
}
