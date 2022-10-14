package conway_cubes

import (
	"fmt"
	"math"
	"sort"
	"strings"
)

func NewCubeSimulationSolver(input string) *solver {
	return &solver{dimensions: parse(input)}
}

func NewHyperCubeSimulationSolver(input string) *hyperCubeSolver {
	return &hyperCubeSolver{dimensions: parse(input)}
}

type solver struct {
	dimensions map[coordinate]cube
}

type hyperCubeSolver struct {
	dimensions map[coordinate]cube
}

type coordinate struct {
	x int
	y int
	z int
	w int
}

type cube int

const (
	inactive cube = iota
	active
)

type pair struct {
	first  coordinate
	second cube
}

func (this cube) String() string {
	switch this {
	case active:
		return "#"
	case inactive:
		return "."
	default:
		panic("this should never happen")
	}
}

func (s *solver) Run() {
	// grow the dimensional space to account for potential new cubes
	// determine max x, y, z
	max_x, max_y, max_z := math.MinInt8, math.MinInt8, math.MinInt8
	min_x, min_y, min_z := math.MaxInt8, math.MaxInt8, math.MaxInt8
	for coord := range s.dimensions {
		if coord.x > max_x {
			max_x = coord.x
		}
		if coord.x < min_x {
			min_x = coord.x
		}
		if coord.y > max_y {
			max_y = coord.y
		}
		if coord.y < min_y {
			min_y = coord.y
		}
		if coord.z > max_z {
			max_z = coord.z
		}
		if coord.z < min_z {
			min_z = coord.z
		}
	}

	// add new z slices
	for i := min_x - 1; i <= max_x+1; i++ {
		for j := min_y - 1; j <= max_y+1; j++ {
			s.dimensions[coordinate{i, j, min_z - 1, 0}] = inactive
			s.dimensions[coordinate{i, j, max_z + 1, 0}] = inactive
		}
	}

	// add additional columns
	for i := min_z - 1; i <= max_z+1; i++ {
		for j := min_y - 1; j <= max_y+1; j++ {
			s.dimensions[coordinate{min_x - 1, j, i, 0}] = inactive
			s.dimensions[coordinate{max_x + 1, j, i, 0}] = inactive
		}
	}

	// add additional rows
	for i := min_z - 1; i <= max_z+1; i++ {
		for j := min_x - 1; j <= max_x+1; j++ {
			s.dimensions[coordinate{j, min_y - 1, i, 0}] = inactive
			s.dimensions[coordinate{j, max_y + 1, i, 0}] = inactive
		}
	}

	dimensional_copy := map[coordinate]cube{}
	for coord, cube := range s.dimensions {
		neighbors := count_active_neighbors(coord, s.dimensions)

		if cube == active {
			if neighbors == 2 || neighbors == 3 {
				dimensional_copy[coord] = active
			} else {
				dimensional_copy[coord] = inactive
			}
		} else if cube == inactive {
			if neighbors == 3 {
				dimensional_copy[coord] = active
			} else {
				dimensional_copy[coord] = inactive
			}
		} else {
			panic(fmt.Sprintf("unknown state for cube '%s' at coord %#v", cube, coord))
		}
	}

	s.dimensions = dimensional_copy
}

func (s *hyperCubeSolver) Run() {
	// grow the dimensional space to account for potential new cubes
	// determine max x, y, z, w
	max_x, max_y, max_z, max_w := math.MinInt8, math.MinInt8, math.MinInt8, math.MinInt8
	min_x, min_y, min_z, min_w := math.MaxInt8, math.MaxInt8, math.MaxInt8, math.MaxInt8
	for coord := range s.dimensions {
		min_x = min(min_x, coord.x)
		max_x = max(max_x, coord.x)

		min_y = min(min_y, coord.y)
		max_y = max(max_y, coord.y)

		min_z = min(min_z, coord.z)
		max_z = max(max_z, coord.z)

		min_w = min(min_w, coord.w)
		max_w = max(max_z, coord.w)
	}

	// add new z slices
	for i := min_x - 1; i <= max_x+1; i++ {
		for j := min_y - 1; j <= max_y+1; j++ {
			for k := min_w - 1; k <= max_w+1; k++ {
				s.dimensions[coordinate{i, j, min_z - 1, k}] = inactive
				s.dimensions[coordinate{i, j, max_z + 1, k}] = inactive
			}
		}
	}

	// add additional columns
	for i := min_z - 1; i <= max_z+1; i++ {
		for j := min_y - 1; j <= max_y+1; j++ {
			for k := min_w - 1; k <= max_w+1; k++ {
				s.dimensions[coordinate{min_x - 1, j, i, k}] = inactive
				s.dimensions[coordinate{max_x + 1, j, i, k}] = inactive
			}
		}
	}

	// add additional rows
	for i := min_z - 1; i <= max_z+1; i++ {
		for j := min_x - 1; j <= max_x+1; j++ {
			for k := min_w - 1; k <= max_w+1; k++ {
				s.dimensions[coordinate{j, min_y - 1, i, k}] = inactive
				s.dimensions[coordinate{j, max_y + 1, i, k}] = inactive
			}
		}
	}

	// add additional w-dimension
	for i := min_x - 1; i <= max_x+1; i++ {
		for j := min_y - 1; j <= max_y+1; j++ {
			for k := min_z - 1; k <= max_z+1; k++ {
				s.dimensions[coordinate{i, j, k, min_w - 1}] = inactive
				s.dimensions[coordinate{i, j, k, max_w + 1}] = inactive
			}
		}
	}

	dimensional_copy := map[coordinate]cube{}
	for coord, cube := range s.dimensions {
		neighbors := count_active_neighbors(coord, s.dimensions)

		if cube == active {
			if neighbors == 2 || neighbors == 3 {
				dimensional_copy[coord] = active
			} else {
				dimensional_copy[coord] = inactive
			}
		} else if cube == inactive {
			if neighbors == 3 {
				dimensional_copy[coord] = active
			} else {
				dimensional_copy[coord] = inactive
			}
		} else {
			panic(fmt.Sprintf("unknown state for cube '%s' at coord %#v", cube, coord))
		}
	}

	s.dimensions = dimensional_copy
}

func (s *solver) SliceAtZIndex(index int) string {
	coords := []pair{}

	for coord, cube := range s.dimensions {
		if coord.z == index {
			coords = append(coords, pair{coord, cube})
		}
	}

	sort.Slice(coords, func(i, j int) bool {
		if coords[i].first.y == coords[j].first.y {
			return coords[i].first.x < coords[j].first.x
		} else {
			return coords[i].first.y < coords[j].first.y
		}
	})

	y_index := math.MinInt8
	result := ""
	for _, pair := range coords {

		if pair.first.y > y_index {
			result = result + "\n"
			y_index = pair.first.y
		}

		result = result + pair.second.String()
	}

	return result + "\n"
}

func (s *solver) ActiveCubes() int {
	return count_active(s.dimensions)
}

func (s *hyperCubeSolver) ActiveCubes() int {
	return count_active(s.dimensions)
}

func count_active(dimensions map[coordinate]cube) int {
	result := 0

	for _, cube := range dimensions {
		if cube == active {
			result += 1
		}
	}

	return result
}

// pragma mark - private

func count_active_neighbors(point coordinate, dimensions map[coordinate]cube) int {
	count := 0
	for z := point.z - 1; z <= point.z+1; z++ {
		for y := point.y - 1; y <= point.y+1; y++ {
			for x := point.x - 1; x <= point.x+1; x++ {
				for w := point.w - 1; w <= point.w+1; w++ {
					if (point == coordinate{x, y, z, w}) {
						continue
					}

					if dimensions[coordinate{x, y, z, w}] == active {
						count++
					}
				}
			}
		}
	}

	return count
}

func parse(input string) map[coordinate]cube {
	result := map[coordinate]cube{}

	lines := strings.Split(input, "\n")

	if lines[0] == "" {
		lines = lines[1:]
	}

	for y, line := range lines {
		for x, char := range strings.Split(line, "") {
			if char == "#" {
				result[coordinate{x, y, 0, 0}] = active
			} else if char == "." {
				result[coordinate{x, y, 0, 0}] = inactive
			} else {
				panic(fmt.Errorf("Unknown dimensional input : '%s'", char))
			}
		}
	}
	return result
}

func min(a, b int) int {
	if a < b {
		return a
	} else {
		return b
	}
}

func max(a, b int) int {
	if a > b {
		return a
	} else {
		return b
	}
}
