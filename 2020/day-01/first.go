package main

import (
	"io/ioutil"
	"strconv"
	"strings"
)

var goal int = 2020

type intPair struct {
	first  int
	second int
}

type intTrio struct {
	first  int
	second int
	third  int
}

func main() {
	input := readInput()

	resultChan := make(chan (intPair), 1)
	for i := range input {
		go checkForFirstDesiredResult(input[i], input, goal, resultChan)
	}

	result := <-resultChan
	println("first answer:", result.first*result.second)

	secondResultChan := make(chan (intTrio), 1)
	for i := range input {
		for j := range input {
			given := intPair{first: input[i], second: input[j]}
			go checkForSecondDesiredResult(given, input, goal, secondResultChan)
		}
	}

	secondResult := <-secondResultChan
	println("second answer:", secondResult.first*secondResult.second*secondResult.third)
}

// pragma mark - solutions
func checkForFirstDesiredResult(given int, input []int, goal int, resultChan chan<- (intPair)) {
	for _, i := range input {
		if given+i != goal {
			continue
		}

		resultChan <- intPair{first: given, second: i}
		return
	}
}

func checkForSecondDesiredResult(given intPair, input []int, goal int, resultChan chan<- (intTrio)) {
	for _, num := range input {
		if given.first+given.second+num != goal {
			continue
		}

		resultChan <- intTrio{
			first:  given.first,
			second: given.second,
			third:  num,
		}
		return
	}
}

// pragma mark - private
func readInput() []int {
	stuff, err := ioutil.ReadFile("input-1.txt")
	if err != nil {
		panic(err)
	}

	contents := string(stuff)
	lines := strings.Split(contents, "\n")

	input := []int{}
	for i := 0; i < len(lines); i++ {
		num, err := strconv.Atoi(lines[i])
		if err != nil {
			continue
		}

		input = append(input, num)
	}

	return input
}
