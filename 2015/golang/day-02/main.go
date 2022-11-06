package main

import (
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	part_one()
	part_two()
}

func part_two() {
	total := 0
	for _, box := range read_input() {
		total += RibbonRequiredFor(box)
	}

	println("solution to part two is", total)

}

func part_one() {
	total := 0
	for _, box := range read_input() {
		total += WrappingPaperFor(box)
	}

	println("solution to part one is", total)
}

func read_input() []Box {
	contents, err := os.ReadFile("input")
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(contents), "\n")

	results := []Box{}
	for _, line := range lines {
		if line == "" {
			break
		}
		pieces := strings.Split(string(line), "x")
		results = append(results, Box{Length: mustConvert(pieces[0]), Width: mustConvert(pieces[1]), Height: mustConvert(pieces[2])})
	}
	return results
}

func mustConvert(dimension string) int {
	result, err := strconv.Atoi(dimension)
	if err != nil {
		panic(err)
	}
	return result
}

type Box struct {
	Length int
	Width  int
	Height int
}

func RibbonRequiredFor(box Box) int {
	lengths := []int{box.Width, box.Length, box.Height}
	sort.Ints(lengths)

	return lengths[0] * 2 + lengths[1] * 2 +
		box.Width * box.Length * box.Height
}

func WrappingPaperFor(box Box) int {
	return smallestSide(box) +
		2*box.Length*box.Width +
		2*box.Width*box.Height +
		2*box.Height*box.Length
}

func smallestSide(box Box) int {
	lengths := []int{box.Width, box.Length, box.Height}
	sort.Ints(lengths)

	return lengths[0] * lengths[1]
}
