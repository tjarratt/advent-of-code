package main

import "testing"

func Test_ValidityPartOne(t *testing.T) {
	return
	assertTrue(t, IsValid(666666), "Expected 666666 to be valid")
	assertFalse(t, IsValid(223450), "Expected 223450 to be invalid")
	assertFalse(t, IsValid(123789), "Expected 123789 to be invalid")
}

func Test_ValidityPartTwo(t *testing.T) {
	assertTrue(t, IsValidPartTwo(222244), "Expected 222244 to be valid")
	assertTrue(t, IsValidPartTwo(223344), "Expected 222244 to be valid")
	assertFalse(t, IsValidPartTwo(666666), "Expected 666666 to be invalid")
	assertFalse(t, IsValidPartTwo(234777), "Expected 123444 to be invalid")
}

func assertTrue(t *testing.T, toCheck bool, message string) {
	if toCheck != true {
		t.Errorf(message)
	}
}

func assertFalse(t *testing.T, toCheck bool, message string) {
	if toCheck != false {
		t.Errorf(message)
	}
}
