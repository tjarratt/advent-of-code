package messages

import (
	"regexp"
	"strconv"
	"strings"
)

func NewSolver(input string) solver {
	return parse(input)
}

type solver struct {
	rules    map[int]string
	messages []string
}

func (s solver) UncorruptedMessages() int {
	result := 0

	for _, message := range s.messages {
		matches, remainder := s.matchesRule(message, 0)

		if matches && len(remainder) == 0 {
			result += 1
		}
	}

	return result
}

var terminalRule = regexp.MustCompile(`"[a-z]"`)

func (s solver) matchesRule(message string, ids ...int) (bool, string) {
	matches_all := true

	for _, id := range ids {
		rule := s.rules[id]

		// if it's terminal, check the rule directly
		if terminalRule.MatchString(rule) {
			if strings.HasPrefix(message, string(rule[1])) {
				tmp := strings.Join(strings.Split(message, "")[1:], "")
				message = tmp
			} else {

				matches_all = false
				break
			}
		} else {
			// otherwise ... recurse ... somehow ???
			sub_matched_any := false
			for _, option := range strings.Split(rule, " | ") {
				rule_ids := []int{}
				for _, str := range strings.Split(option, " ") {
					as_int, err := strconv.Atoi(str)
					if err != nil {
						panic(err)
					}

					rule_ids = append(rule_ids, as_int)
				}

				if ok, remainder := s.matchesRule(message, rule_ids...); ok {
					message = remainder
					sub_matched_any = true
					break
				}
			}

			if sub_matched_any == false {
				matches_all = false
				break
			}
		}
	}

	return matches_all, message
}

// pragma mark - private

func parse(input string) solver {
	pieces := strings.Split(input, "\n\n")
	rules := parseRules(pieces[0])
	messages := parseMessages(pieces[1])

	return solver{rules, messages}
}

func parseRules(input string) map[int]string {
	result := map[int]string{}

	for _, line := range strings.Split(input, "\n") {
		if len(line) == 0 {
			continue
		}

		pieces := strings.Split(line, ": ")
		key, err := strconv.Atoi(pieces[0])
		if err != nil {
			panic(err)
		}

		result[key] = pieces[1]
	}

	return result
}

func parseMessages(input string) []string {
	result := []string{}

	for _, line := range strings.Split(input, "\n") {
		if len(line) == 0 {
			continue
		}
		result = append(result, line)
	}

	return result
}
