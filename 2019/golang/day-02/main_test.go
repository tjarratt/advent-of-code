package main

import (
	"../intcode"
	"reflect"
	"testing"
)

func Test_SimpleIntcodeCases(t *testing.T) {
	Verify(Scenario{[]int{1, 0, 0, 0, 99}, []int{2, 0, 0, 0, 99}}, t)
	Verify(Scenario{[]int{2, 3, 0, 3, 99}, []int{2, 3, 0, 6, 99}}, t)
	Verify(Scenario{[]int{2, 4, 4, 5, 99, 0}, []int{2, 4, 4, 5, 99, 9801}}, t)
	Verify(Scenario{[]int{1, 1, 1, 4, 99, 5, 6, 0, 99}, []int{30, 1, 1, 4, 2, 5, 6, 0, 99}}, t)
}

func Verify(scenario Scenario, t *testing.T) {
	computer := intcode.NewIntcodeComputer(scenario.given)
	computer.RunUntilHalt()

	if !reflect.DeepEqual(computer.Memory(), scenario.expected) {
		t.Errorf("Expected memory to be (%#v) but it was (%#v)", scenario.expected, computer.Memory())
	}
}

type Scenario struct {
	given    []int
	expected []int
}
