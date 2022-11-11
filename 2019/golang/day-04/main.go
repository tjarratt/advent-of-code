package main

import (
	"strconv"
	"strings"
)

func main() {
	total_part_one := 0
	total_part_two := 0
	for i := 168630; i <= 718098; i++ {
		if IsValid(i) {
			total_part_one += 1
		}
		if IsValidPartTwo(i) {
			total_part_two += 1
		}
	}

	println("the solution to part one is", total_part_one)
	println("the solution to part two is", total_part_two)
}

func IsValid(input int) bool {
	password := strconv.Itoa(input)
	if len(password) != 6 {
		return false
	}
	if input < 168630 || input > 718098 {
		return false
	}

	pieces := strings.Split(password, "")
	hasDuplicate := false
	for i := 0; i < len(pieces)-1; i++ {
		this := pieces[i]
		next := pieces[i+1]

		if strings.Compare(this, next) == 0 {
			hasDuplicate = true
		}
		a, err := strconv.Atoi(this)
		if err != nil {
			panic(err)
		}
		b, err := strconv.Atoi(next)
		if err != nil {
			panic(err)
		}
		if a > b {
			return false
		}

		this = next
	}
	if hasDuplicate == false {
		return false
	}

	return true
}

func IsValidPartTwo(input int) bool {
	password := strconv.Itoa(input)
	if len(password) != 6 {
		return false
	}
	if input < 168630 || input > 718098 {
		return false
	}

	pieces := strings.Split(password, "")
	hasDuplicate := false
	for i := 0; i < len(pieces)-1; i++ {
		this := pieces[i]
		next := pieces[i+1]
		a, err := strconv.Atoi(this)
		if err != nil {
			panic(err)
		}
		b, err := strconv.Atoi(next)
		if err != nil {
			panic(err)
		}
		if a > b {
			return false
		}

		if (len(pieces) - 1 - i) > 2 {
			after := pieces[i+2]
			if strings.Compare(this, next) == 0 && strings.Compare(this, after) != 0 {
				hasDuplicate = true
			}
		} else {
			if strings.Compare(this, next) == 0 {
				hasDuplicate = true
			}
		}

		this = next
	}
	if hasDuplicate == false {
		return false
	}

	return true
}
