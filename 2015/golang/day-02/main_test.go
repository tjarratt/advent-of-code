package main

import (
	"testing"
)

func Test_Simple_Case(t *testing.T) {
	box := Box{Length: 2, Width: 3, Height: 4}
	result := WrappingPaperFor(box)
	if result != 58 {
		t.Errorf("expected result to be %d but it was %d", 58, result)
	}
}

func Test_OblongBox(t *testing.T) {
	box := Box{Length: 1, Width: 1, Height: 10}
	result := WrappingPaperFor(box)
	if result != 43 {
		t.Errorf("expected result to be %d but it was %d", 43, result)
	}
}

func Test_Ribbon(t *testing.T) {
	regular_box := Box{Length: 2, Width: 3, Height: 4}

	result := RibbonRequiredFor(regular_box)
	if result != 34 {
		t.Errorf("expected %d got got %d", 34, result)
	}

	oblong_box := Box{Length: 1, Width: 1, Height: 10}
	result = RibbonRequiredFor(oblong_box)
	if result != 14 {
		t.Errorf("expected %d but got %d", 14, result)
	}
}
