package passport

import (
	"fmt"
	"io"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

type Validator interface {
	Valid() []Passport
	Invalid() []Passport
}

type validator struct {
	passports []Passport
}

type Passport struct {
	BirthYear      string
	IssueYear      string
	ExpirationYear string
	Height         string
	HairColor      string
	EyeColor       string
	PassportId     string
	CountryId      string
}

func PassportValidator(reader io.Reader) Validator {
	return &validator{passports: parse(reader)}
}

func StrictPassportValidator(reader io.Reader) Validator {
	return &validator{passports: parseStrictly(reader)}
}

func (v *validator) Valid() []Passport {
	valid := []Passport{}
	for _, passport := range v.passports {
		if isValid(passport) {
			valid = append(valid, passport)
		}
	}

	return valid
}

func (v *validator) Invalid() []Passport {
	invalid := []Passport{}

	for _, passport := range v.passports {
		if isValid(passport) {
			continue
		}

		invalid = append(invalid, passport)
	}

	return invalid
}

func isValid(passport Passport) bool {
	if passport.BirthYear == "" ||
		passport.IssueYear == "" ||
		passport.ExpirationYear == "" ||
		passport.Height == "" ||
		passport.HairColor == "" ||
		passport.EyeColor == "" ||
		passport.PassportId == "" {
		return false
	}

	return true
}

func parse(reader io.Reader) []Passport {
	passports := []Passport{}

	input, err := ioutil.ReadAll(reader)
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(input), "\n")
	var passport = Passport{}
	re := regexp.MustCompile("([a-z]+:[#a-zA-Z0-9]+)")

	for _, line := range lines {
		if line == "\n" || line == "" {
			passports = append(passports, passport)
			passport = Passport{}
			continue
		}

		matches := re.FindAllStringSubmatch(line, -1)
		for _, match := range matches {
			pieces := strings.Split(match[0], ":")
			switch pieces[0] {
			case "ecl":
				passport.EyeColor = pieces[1]
			case "pid":
				passport.PassportId = pieces[1]
			case "eyr":
				passport.ExpirationYear = pieces[1]
			case "hcl":
				passport.HairColor = pieces[1]
			case "byr":
				passport.BirthYear = pieces[1]
			case "iyr":
				passport.IssueYear = pieces[1]
			case "cid":
				passport.CountryId = pieces[1]
			case "hgt":
				passport.Height = pieces[1]
			default:
				panic(fmt.Sprintf("Strange unknown passport field '%s'", pieces[0]))
			}
		}
	}

	return passports
}

func parseStrictly(reader io.Reader) []Passport {
	passports := []Passport{}
	input, err := ioutil.ReadAll(reader)
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(input), "\n")
	var passport = Passport{}
	re := regexp.MustCompile("([a-z]+:[#a-zA-Z0-9]+)")

	for _, line := range lines {
		if line == "\n" || line == "" {
			passports = append(passports, passport)
			passport = Passport{}
			continue
		}

		matches := re.FindAllStringSubmatch(line, -1)
		for _, match := range matches {
			pieces := strings.Split(match[0], ":")
			switch pieces[0] {
			case "ecl":
				if isInvalidEyeColor(pieces[1]) {
					continue
				}
				passport.EyeColor = pieces[1]
			case "pid":
				if isInvalidPassportId(pieces[1]) {
					continue
				}
				passport.PassportId = pieces[1]
			case "eyr":
				if isInvalidExpirationYear(pieces[1]) {
					continue
				}
				passport.ExpirationYear = pieces[1]
			case "hcl":
				if isInvalidHairColor(pieces[1]) {
					continue
				}
				passport.HairColor = pieces[1]
			case "byr":
				if isInvalidBirthYear(pieces[1]) {
					continue
				}
				passport.BirthYear = pieces[1]
			case "iyr":
				if isInvalidIssueYear(pieces[1]) {
					continue
				}
				passport.IssueYear = pieces[1]
			case "cid":
				// no validation, can be missing
				passport.CountryId = pieces[1]
			case "hgt":
				if isInvalidHeight(pieces[1]) {
					continue
				}
				passport.Height = pieces[1]
			default:
				panic(fmt.Sprintf("Strange unknown passport field '%s'", pieces[0]))
			}
		}
	}

	return passports
}

var validEyeColor = regexp.MustCompile("^(amb|blu|brn|gry|grn|hzl|oth)$")

func isInvalidEyeColor(color string) bool {
	return validEyeColor.MatchString(color) == false
}

var validPid = regexp.MustCompile("^[0-9]{9}$")

func isInvalidPassportId(pid string) bool {
	return validPid.MatchString(pid) == false
}

func isInvalidExpirationYear(year string) bool {
	yearInt, err := strconv.Atoi(year)
	if err != nil {
		return true
	}

	return yearInt < 2020 || yearInt > 2030
}

var validHairColor = regexp.MustCompile("^#[a-f0-9]{6}$")

func isInvalidHairColor(color string) bool {
	return validHairColor.MatchString(color) == false
}

func isInvalidBirthYear(year string) bool {
	yearInt, err := strconv.Atoi(year)
	if err != nil {
		return true
	}

	return yearInt < 1920 || yearInt > 2002
}

func isInvalidIssueYear(year string) bool {
	yearInt, err := strconv.Atoi(year)
	if err != nil {
		return true
	}

	return yearInt < 2010 || yearInt > 2020
}

var heightCentimeters = regexp.MustCompile("^([0-9]+)cm$")
var heightInches = regexp.MustCompile("^([0-9]+)in$")

func isInvalidHeight(height string) bool {
	matches := heightCentimeters.FindStringSubmatch(height)
	if len(matches) > 0 {
		centimeters, err := strconv.Atoi(matches[1])
		if err != nil {
			return true
		}

		return centimeters < 150 || centimeters > 193
	}

	matches = heightInches.FindStringSubmatch(height)
	if len(matches) == 0 {
		return true
	}

	inches, err := strconv.Atoi(matches[1])
	if err != nil {
		return true
	}

	return inches < 59 || inches > 76
}
