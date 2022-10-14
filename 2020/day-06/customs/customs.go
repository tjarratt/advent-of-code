package customs

import (
	"strings"
)

type customsCounter struct {
	groups []Group
}

type Group struct {
	answers []string
}

// pragma mark - Part 1
func CustomsCounter(input string) customsCounter {
	return customsCounter{groups: parse(input)}
}

// pragma mark - Part 2
func IntersectionCustomsCounter(input string) customsCounter {
	return customsCounter{groups: parseIntersections(input)}
}

// pragma mark - interface for tests to verify I was on the right path
func (counter customsCounter) Sum() int {
	sum := 0

	for _, group := range counter.groups {
		sum += len(group.answers)
	}

	return sum
}

func (counter customsCounter) Groups() []Group {
	return counter.groups
}

func (group Group) Responses() []string {
	return group.answers
}

// pragma mark - private
func parse(input string) []Group {
	groups := []Group{}
	answers := map[string]int{}

	for _, line := range strings.Split(input, "\n") {
		if len(line) == 0 {
			groups = append(groups, Group{answers: keysFromMap(answers)})
			answers = map[string]int{}
			continue
		}

		for _, answer := range strings.Split(line, "") {
			answers[answer] = 1
		}
	}

	return groups
}

func keysFromMap(dict map[string]int) []string {
	keys := []string{}

	for key := range dict {
		keys = append(keys, key)
	}

	return keys
}

func parseIntersections(input string) []Group {
	groups := []Group{}
	answers := map[string]int{}
	linesRead := 0

	for _, line := range strings.Split(input, "\n") {

		if len(line) == 0 {
			groups = append(groups, Group{answers: keysFromMapWithValue(answers, linesRead)})
			answers = map[string]int{}
			linesRead = 0
			continue
		}

		for _, answer := range strings.Split(line, "") {
			answers[answer] += 1
		}

		linesRead += 1
	}

	return groups
}

func keysFromMapWithValue(dict map[string]int, withValue int) []string {
	keys := []string{}

	for key, value := range dict {
		if value != withValue {
			continue
		}

		keys = append(keys, key)
	}

	return keys
}
