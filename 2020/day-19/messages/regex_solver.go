package messages

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

func NewAdvancedSolver(input string) regex_solver {
	s := parse(input)

	return regex_solver{
		rules:    s.rules,
		messages: s.messages,
	}
}

type regex_solver struct {
	rules    map[int]string
	messages []string
}

func (s regex_solver) UncorruptedMessages() int {
	str := s.regex_string_from_rules(0)
	valid_regexp := regexp.MustCompile("^" + str + "$")

	result := 0
	for _, msg := range s.messages {
		if valid_regexp.MatchString(msg) {
			result += 1
		}
	}

	return result
}

//pragma mark -- private
func (s regex_solver) regex_string_from_rules(ids ...int) string {
	result := ""

	for _, id := range ids {
		rule := s.rules[id]

		// if terminal, yield that back
		if strings.HasPrefix(rule, "\"") {
			result += strings.Split(rule, "")[1]
		} else {
			if id == 8 {
				result += s.regex_string_from_rules(42) + "+"
			} else if id == 11 {
				first := s.regex_string_from_rules(42)
				last := s.regex_string_from_rules(31)

				greebles := []string{first + last}
				for i := 2; i <= 10; i++ {
					greebles = append(greebles, fmt.Sprintf("%s{%d}%s{%d}", first, i, last, i))
				}

				result += "(" + strings.Join(greebles, "|") + ")"

			} else {
				result += s.solve_subrule(rule)
			}
		}
	}

	return result
}

func (s regex_solver) solve_subrule(rule string) string {
	inner_results := []string{}
	for _, piece := range strings.Split(rule, " | ") {
		inner_ids := []int{}
		for _, rule_str := range strings.Split(piece, " ") {
			as_int, _ := strconv.Atoi(rule_str)
			inner_ids = append(inner_ids, as_int)
		}

		inner_results = append(inner_results, s.regex_string_from_rules(inner_ids...))
	}
	return "(" + strings.Join(inner_results, "|") + ")"
}
