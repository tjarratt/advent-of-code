package tickets

import (
	"regexp"
	"sort"
	"strconv"
	"strings"
)

func NewFieldScanner(input string) solver {
	return parse(input)
}

type solver struct {
	rules []rule

	my_ticket []int

	nearby_tickets [][]int
}

type rule struct {
	name     string
	validity fieldValidity
}

type fieldValidity struct {
	first  validRange
	second validRange
}

func (r rule) Valid(field int) bool {
	valid := false

	if field >= r.validity.first.min && field <= r.validity.first.max {
		valid = valid || true
	}
	if field >= r.validity.second.min && field <= r.validity.second.max {
		valid = valid || true
	}

	return valid
}

type validRange struct {
	min int
	max int
}

func (s solver) ErrorRate() int {
	result := 0

	for _, ticket := range s.nearby_tickets {
		for _, field := range ticket {
			any_valid := false
			for _, rule := range s.rules {
				if rule.Valid(field) {
					any_valid = true
					break
				}
			}

			if !any_valid {
				result += field
			}
		}
	}

	return result
}

func (s solver) MyTicket() map[string]int {
	ticket := map[string]int{}

	s.rulesWithFieldIndex(func(rule rule, field_index int) {
		ticket[rule.name] = s.my_ticket[field_index]
	})

	return ticket
}

func (s solver) rulesWithFieldIndex(cb func(rule, int)) {
	sort.Slice(s.rules, func(i, j int) bool {
		return s.countMatchingFields(s.rules[i]) < s.countMatchingFields(s.rules[j])
	})

	fields_seen := map[int]bool{}
	for _, rule := range s.rules {
		for _, field := range s.matchingFields(rule) {
			if fields_seen[field] {
				continue
			}

			fields_seen[field] = true
			cb(rule, field)
		}
	}
}

func (s solver) countMatchingFields(rule rule) int {
	return len(s.matchingFields(rule))
}

func (s solver) matchingFields(rule rule) []int {
	other_tickets := discard_invalid(s.nearby_tickets, s.rules)

	matches := []int{}

	for i := 0; i < len(other_tickets[0]); i++ {
		all_valid := true
		for _, ticket := range other_tickets {
			if !rule.Valid(ticket[i]) {
				all_valid = false
				break
			}
		}
		if all_valid {
			matches = append(matches, i)
		}
	}

	return matches
}

func discard_invalid(tickets [][]int, rules []rule) [][]int {
	valid_tickets := [][]int{}

	for _, ticket := range tickets {
		fields_valid := 0
		for _, field := range ticket {
			for _, rule := range rules {
				if rule.Valid(field) {
					fields_valid++
					break
				}
			}
		}

		if fields_valid == len(ticket) {
			valid_tickets = append(valid_tickets, ticket)
		}
	}

	return valid_tickets
}

func parse(input string) solver {
	rules := []rule{}
	nearby_tickets := [][]int{}

	sections := strings.Split(input, "\n\n")
	for _, line := range strings.Split(sections[0], "\n") {
		if len(line) == 0 {
			break
		}

		pieces := strings.Split(line, ":")
		rules = append(rules, rule{name: pieces[0], validity: parseValidity(pieces[1])})
	}

	my_ticket := []int{}
	for _, char := range strings.Split(strings.Split(sections[1], "\n")[1], ",") {
		field, err := strconv.Atoi(char)
		if err != nil {
			panic(err)
		}

		my_ticket = append(my_ticket, field)
	}

	for _, line := range strings.Split(sections[2], "\n")[1:] {
		if len(line) == 0 {
			break
		}

		ticket := []int{}
		for _, raw := range strings.Split(line, ",") {
			field, err := strconv.Atoi(raw)
			if err != nil {
				panic(err)
			}

			ticket = append(ticket, field)
		}
		nearby_tickets = append(nearby_tickets, ticket)
	}

	return solver{
		rules:          rules,
		my_ticket:      my_ticket,
		nearby_tickets: nearby_tickets,
	}
}

func parseValidity(input string) fieldValidity {
	re := regexp.MustCompile("([0-9]+)-([0-9]+)")

	matches := re.FindAllString(input, -1)

	return fieldValidity{
		first:  mustParseRange(matches[0]),
		second: mustParseRange(matches[1]),
	}
}

func mustParseRange(raw string) validRange {
	pieces := strings.Split(raw, "-")

	min, err := strconv.Atoi(pieces[0])
	if err != nil {
		panic(err)
	}

	max, err := strconv.Atoi(pieces[1])
	if err != nil {
		panic(err)
	}

	return validRange{min: min, max: max}
}
