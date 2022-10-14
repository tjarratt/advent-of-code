package rules

import (
	"strings"
)

type CheckedPassword struct {
	Password string
	Rule     Rule
}

type Rule struct {
	Letter  string
	Minimum int
	Maximum int
}

func IsValid(password string, rule Rule) bool {
	count := strings.Count(password, rule.Letter)

	if count < rule.Minimum {
		return false
	}

	if count > rule.Maximum {
		return false
	}

	return true
}

func IsValidTobogganPassword(password string, rule Rule) bool {
	hasFirst := strings.EqualFold(string(password[rule.Minimum-1]), rule.Letter)
	hasSecond := strings.EqualFold(string(password[rule.Maximum-1]), rule.Letter)

	return xnor(hasFirst, hasSecond)
}

func xnor(a, b bool) bool {
	if a && !b || !a && b {
		return true
	}

	return false
}
