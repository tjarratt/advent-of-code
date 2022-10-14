package toboggan_test

import (
	"io/ioutil"
	"testing"

	. "github.com/tjarratt/advent-of-code-2020/day-03/toboggan"
)

func Test_trees_hit_given_trajectory(t *testing.T) {
	fixture, err := ioutil.ReadFile("fixtures/1.txt")
	if err != nil {
		t.Errorf("Unexpected error: %#v", err)
	}

	grid := NewGrid(fixture)

	trees := grid.CountTrees(Trajectory{Right: 3, Down: 1})

	if trees != 7 {
		t.Errorf("Expected 7 trees but actually got %d", trees)
	}
}

func Test_read_grid_from_input(t *testing.T) {
	fixture, err := ioutil.ReadFile("fixtures/1.txt")
	if err != nil {
		t.Errorf("Unexpected error: %#v", err)
	}

	grid := NewGrid(fixture)

	if len(grid.Column(0)) != 11 {
		t.Errorf("expected 11 columns but got %d", len(grid.Column(0)))
	}

	if len(grid.Row(0)) != 11 {
		t.Errorf("Expected 10 rows but got %d", len(grid.Row(0)))
	}
}

func Test_part_two(t *testing.T) {
	fixture, err := ioutil.ReadFile("fixtures/1.txt")
	if err != nil {
		t.Errorf("Unexpected error: %#v", err)
	}

	grid := NewGrid(fixture)

	input := []Trajectory{
		{Right: 1, Down: 1},
		{Right: 3, Down: 1},
		{Right: 5, Down: 1},
		{Right: 7, Down: 1},
		{Right: 1, Down: 2},
	}

	results := []int{}
	for _, trajectory := range input {
		results = append(results, grid.CountTrees(trajectory))
	}

	product := 1
	for _, x := range results {
		product = product * x
	}

	if product != 336 {
		t.Errorf("Expected to get 236 but instead got %d", product)
	}
}
