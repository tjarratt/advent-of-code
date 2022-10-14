package tiles

import (
	"fmt"
	"strconv"
	"strings"
)

func NewSolver(input string) solver {
	return solver{tiles: parse(input)}
}

type solver struct {
	tiles []tile
	cache map[int]int
}

type tile struct {
	id   int
	data []string
}

func (s solver) Tiles() []tile {
	return s.tiles
}

func (s solver) Corners() []int {
	result := []int{}

	// strategy :: look for FOUR pieces each having two edges that do not match
	lookup := map[int][][]int{}
	s.cache = map[int]int{}

	for _, tile := range s.tiles {
		lookup[tile.id] = s.computeBorders(tile.data)
	}

	for id, borders := range lookup {
		if is_corner(borders, s.cache) {
			result = append(result, id)
		}
	}

	return result
}

func (s solver) Image(width, height int) (string, int) {

	// build up a list of tiles with edges and appearance count
	remainingPieces := s.parsePieces()

	solution := make([][]puzzlePiece, height)
	solvedPieces := map[int]puzzlePiece{}

	// pick a corner piece and place it first
	for _, piece := range remainingPieces {
		if piece.orientations[0].isTopLeftCorner() {
			solution[0] = append(solution[0], piece)
			break
		}
	}

	topLeftCorner := solution[0][0]

	tmp := func(p puzzlePiece) {
		solvedPieces[p.id] = p
		delete(remainingPieces, p.id)
	}
	tmp(topLeftCorner)

	// solve top border
	prev := topLeftCorner
	for i := 0; i < 11; i++ {
		for _, piece := range remainingPieces {
			var next puzzlePiece

			for index, orientation := range piece.orientations {
				if orientation.edges[2] == prev.orientations[0].edges[3] && orientation.edges[0].frequency == 1 {
					next = piece.choose(index)
					break
				}
			}

			if next.id != 0 {
				solution[0] = append(solution[0], next)
				tmp(next)
				prev = next
				break
			}
		}
	}

	// solve the left border
	prev = topLeftCorner
	for i := 1; i < height; i++ {
		for _, piece := range remainingPieces {
			var next puzzlePiece

			for index, orientation := range piece.orientations {
				if orientation.edges[0] == prev.orientations[0].edges[1] && orientation.edges[2].frequency == 1 {
					next = piece.choose(index)
					break
				}
			}

			if next.id != 0 {
				solution[i] = append(solution[i], next)
				tmp(next)
				prev = next
				break
			}
		}
	}

	// solve the bottom border
	prev = solution[height-1][0]
	for i := 1; i < height; i++ {
		for _, piece := range remainingPieces {
			var next puzzlePiece

			for index, orientation := range piece.orientations {
				if orientation.edges[2] == prev.orientations[0].edges[3] && orientation.edges[1].frequency == 1 {
					next = piece.choose(index)
					break
				}
			}

			if next.id != 0 {
				solution[height-1] = append(solution[height-1], next)
				tmp(next)
				prev = next
				break
			}
		}
	}

	// solve the remaining rows
	for y := 1; y < height-1; y++ {
		for x := 1; x < width; x++ {
			left_neighbor := solution[y][x-1]
			top_neighbor := solution[y-1][x]

			top_edge := top_neighbor.orientations[0].edges[1]
			left_edge := left_neighbor.orientations[0].edges[3]

			var next puzzlePiece
			for _, piece := range remainingPieces {
				for index, orientation := range piece.orientations {
					if orientation.edges[2].Int() == left_edge.Int() &&
						orientation.edges[0].Int() == top_edge.Int() {
						next = piece.choose(index)
						break
					}
				}

				if next.id != 0 {
					break
				}
			}

			if next.id != 0 {
				solution[y] = append(solution[y], next)
				tmp(next)
				prev = next
			} else {
				panic("This should never occur.")
			}
		}
	}

	image := ""

	// for each row of tiles
	for y_tile := 0; y_tile < len(solution); y_tile++ {
		// for each of the rows in that image
		for y_row := 0; y_row < len(solution[y_tile][0].data); y_row++ {
			// for each of the tiles in this slice
			for _, tile := range solution[y_tile] {
				line := tile.data[y_row]

				if y_row > 0 && y_row < len(solution[y_tile][0].data)-1 {
					pieces := strings.Split(line, "")
					image += strings.Join(pieces[1:len(pieces)-1], "")
				}
			}
			if y_row > 0 && y_row < len(solution[y_tile][0].data)-1 {
				image += "\n"
			}
		}
	}

	// scan line by line for the sea monsters
	// mark the grid (somehow)
	// count locations w/o seamonster

	pieces := strings.Split(image, "\n")
	oriented_image := strings.Join(rotateLeft(pieces[0:len(pieces)-1]), "\n")
	lines := strings.Split(oriented_image, "\n")
	gridded := make([][]point, len(lines))

	for y, line := range lines {
		for _, str := range strings.Split(line, "") {
			gridded[y] = append(gridded[y], point{str, false})
		}
	}

	// walk through gridded 0 to len(gridded) - 3
	// look for a match, mark those tiles
	// walk again through gridded
	// count up all the #'s that are not marked
	for y, row := range gridded {
		for x, _ := range row {
			scanForSeaMonsters(gridded, x, y)
		}
	}

	total := 0
	for _, row := range gridded {
		for _, point := range row {
			if point.str == "#" && !point.marked {
				total += 1
			}
		}
	}

	return oriented_image, total
}

func scanForSeaMonsters(grid [][]point, x, y int) {
	if y >= len(grid)-3 || x >= len(grid[0])-20 {
		return
	}

	points := [][]int{
		{0, 1},
		{1, 2},
		{4, 2},
		{5, 1},
		{6, 1},
		{7, 2},
		{10, 2},
		{11, 1},
		{12, 1},
		{13, 2},
		{16, 2},
		{17, 1},
		{18, 1},
		{19, 1},
		{18, 0},
	}

	for _, point := range points {
		if grid[y+point[1]][x+point[0]].str != "#" {
			return
		}
	}

	for _, point := range points {
		grid[y+point[1]][x+point[0]].marked = true
	}
}

type point struct {
	str    string
	marked bool
}

type puzzlePiece struct {
	id           int
	data         []string
	orientations []orientation
}

func (p puzzlePiece) choose(index int) puzzlePiece {
	var data []string

	switch index {
	case 0:
		data = p.data
	case 1:
		// rotate left
		data = rotateLeft(p.data)
	case 2:
		// rotate right
		data = rotateRight(p.data)
	case 3:
		// rotate 180
		data = rotate180(p.data)
	case 4:
		// vertical flip about horizontal axis
		data = flipOverHorizontalAxis(p.data)
	case 5:
		// horizontal flip about vertical axis
		data = flipOverVerticalAxis(p.data)
	case 6:
		// horizontal flip, then rotate left (anti-clockwise)
		data = rotateLeft(flipOverVerticalAxis(p.data))
	case 7:
		// horizontal flip, then rotate right
		data = rotateRight(flipOverVerticalAxis(p.data))
	case 8:
		// horizontal flip, then rotate 180
		data = rotate180(flipOverVerticalAxis(p.data))
	case 9:
		// vertical flip, then rotate left
		data = rotateLeft(flipOverHorizontalAxis(p.data))
	case 10:
		// vertical flip, then rotate right
		data = rotateRight(flipOverHorizontalAxis(p.data))
	case 11:
		// vertical flip, then rotate 180
		data = rotate180(flipOverHorizontalAxis(p.data))
	default:
		panic(fmt.Sprintf("Unexpected orientation: %d", index))
	}

	return puzzlePiece{
		id:           p.id,
		data:         data,
		orientations: []orientation{p.orientations[index]},
	}
}

func flipOverHorizontalAxis(data []string) []string {
	grid := make([][]string, len(data))
	for y, line := range data {
		for _, str := range strings.Split(line, "") {
			grid[y] = append(grid[y], str)
		}
	}

	// only the y dimension gets flipped
	result := make([]string, len(data))
	for x := 0; x < len(grid[0]); x++ {
		for y := 0; y < len(grid); y++ {
			y_index := len(grid) - 1 - y
			result[y] += grid[y_index][x]
		}
	}

	return result
}

func flipOverVerticalAxis(data []string) []string {
	grid := make([][]string, len(data))
	for y, line := range data {
		for _, str := range strings.Split(line, "") {
			grid[y] = append(grid[y], str)
		}
	}

	// only the x dimension gets flipped
	result := make([]string, len(data))
	for x := 0; x < len(grid[0]); x++ {
		for y := 0; y < len(grid); y++ {
			x_index := len(grid[0]) - 1 - x
			result[y] += grid[y][x_index]
		}
	}

	return result
}

func rotate180(data []string) []string {
	grid := make([][]string, len(data))
	for y, line := range data {
		for _, str := range strings.Split(line, "") {
			grid[y] = append(grid[y], str)
		}
	}

	// everything gets flipped
	rotated := make([]string, len(data))
	for x := 0; x < len(grid[0]); x++ {
		for y := 0; y < len(grid); y++ {
			x_index := len(grid[0]) - 1 - x
			y_index := len(grid) - 1 - y
			rotated[y] += grid[y_index][x_index]
		}
	}

	return rotated
}

func rotateLeft(data []string) []string {
	grid := make([][]string, len(data))
	for y, line := range data {
		for _, str := range strings.Split(line, "") {
			grid[y] = append(grid[y], str)
		}
	}

	rotated := make([]string, len(data))
	for x := 0; x < len(grid[0]); x++ {
		for y := 0; y < len(grid); y++ {
			x_index := len(grid[0]) - 1 - x
			rotated[x] += grid[y][x_index]
		}
	}

	return rotated
}

func rotateRight(data []string) []string {
	grid := make([][]string, len(data))
	for y, line := range data {
		for _, str := range strings.Split(line, "") {
			grid[y] = append(grid[y], str)
		}
	}

	rotated := make([]string, len(data))
	for x := 0; x < len(grid[0]); x++ {
		for y := len(grid) - 1; y >= 0; y++ {
			rotated[len(grid)-1-y] = grid[y][x]
		}
	}

	return rotated
}

type orientation struct {
	edges []edge
}

type edge struct {
	data      string
	frequency int
}

func (e edge) String() string {
	return strconv.Itoa(e.Int())
}

func (e edge) Int() int {
	return value_for(strings.Split(e.data, ""))
}

func (o orientation) isTopLeftCorner() bool {
	return o.isTopBorder() && o.isLeftBorder()
}

func (o orientation) isTopBorder() bool {
	return o.edges[0].frequency == 1
}

func (o orientation) isLeftBorder() bool {
	return o.edges[2].frequency == 1
}

func (s solver) parsePieces() map[int]puzzlePiece {
	result := map[int]puzzlePiece{}

	lookup := map[int][][]int{}
	s.cache = map[int]int{}

	for _, tile := range s.tiles {
		lookup[tile.id] = s.computeBorders(tile.data)
	}

	for _, tile := range s.tiles {
		result[tile.id] = puzzlePiece{
			id:           tile.id,
			data:         tile.data,
			orientations: s.orientationsFor(tile.data),
		}
	}

	return result
}

func (s solver) orientationsFor(data []string) []orientation {
	return []orientation{
		// 0 identity
		{
			edges: []edge{
				s.topSlice(data), s.bottomSlice(data),
				s.leftSlice(data), s.rightSlice(data),
			},
		},
		// 1. rotate left (anti-clockwise)
		{
			edges: []edge{
				s.rightSlice(data), s.leftSlice(data),
				s.flip(s.topSlice(data)), s.flip(s.bottomSlice(data)),
			},
		},
		// 2. rotate right (clockwise)
		{
			edges: []edge{
				s.flip(s.leftSlice(data)), s.flip(s.rightSlice(data)),
				s.bottomSlice(data), s.topSlice(data),
			},
		},
		// 3. rotate 180 degrees
		{
			edges: []edge{
				s.flip(s.bottomSlice(data)), s.flip(s.topSlice(data)),
				s.flip(s.rightSlice(data)), s.flip(s.leftSlice(data)),
			},
		},
		// 4. vertical flip over horizontal axis
		{
			edges: []edge{
				s.bottomSlice(data), s.topSlice(data),
				s.flip(s.leftSlice(data)), s.flip(s.rightSlice(data)),
			},
		},
		// 5. horizontal flip over vertical axis
		{
			edges: []edge{
				s.flip(s.topSlice(data)), s.flip(s.bottomSlice(data)),
				s.rightSlice(data), s.leftSlice(data),
			},
		},
		// 6. horizontal flip, then rotate left
		{
			edges: []edge{
				s.leftSlice(data), s.rightSlice(data),
				s.topSlice(data), s.bottomSlice(data),
			},
		},
		// 7. horizontal flip, then rotate right
		{
			edges: []edge{
				s.flip(s.rightSlice(data)), s.flip(s.leftSlice(data)),
				s.flip(s.topSlice(data)), s.flip(s.bottomSlice(data)),
			},
		},
		// 8. horizontal flip, then rotate 180
		{
			edges: []edge{
				s.bottomSlice(data), s.topSlice(data),
				s.flip(s.leftSlice(data)), s.flip(s.rightSlice(data)),
			},
		},
		// 9. vertical flip, then rotate left
		{
			edges: []edge{
				s.flip(s.rightSlice(data)), s.flip(s.leftSlice(data)),
				s.flip(s.bottomSlice(data)), s.flip(s.topSlice(data)),
			},
		},
		// 10. vertical flip, then rotate right
		{
			edges: []edge{
				s.leftSlice(data), s.rightSlice(data),
				s.topSlice(data), s.bottomSlice(data),
			},
		},
		// 11. vertical flip, then rotate 180
		{
			edges: []edge{
				s.flip(s.topSlice(data)), s.flip(s.bottomSlice(data)),
				s.rightSlice(data), s.leftSlice(data),
			},
		},
	}
}

func (s solver) flip(e edge) edge {
	data := make([]string, len(e.data))
	for i, char := range e.data {
		data[len(data)-i-1] = string(char)
	}

	return edge{data: strings.Join(data, ""), frequency: s.cache[value_for(data)]}
}

// top and bottom always read their values from left to right
func (s solver) topSlice(data []string) edge {
	return edge{
		data:      data[0],
		frequency: s.cache[value_for(strings.Split(data[0], ""))],
	}
}

func (s solver) bottomSlice(data []string) edge {
	return edge{
		data:      data[len(data)-1],
		frequency: s.cache[value_for(strings.Split(data[len(data)-1], ""))],
	}
}

// left and right always read their values from top to bottomm
func (s solver) leftSlice(data []string) edge {
	slice := []string{}
	for index := 0; index < len(data); index++ {
		slice = append(slice, strings.Split(data[index], "")[0])
	}

	return edge{
		data:      strings.Join(slice, ""),
		frequency: s.cache[value_for(slice)],
	}
}

func (s solver) rightSlice(data []string) edge {
	slice := []string{}
	for index := 0; index < len(data); index++ {
		pieces := strings.Split(data[index], "")
		slice = append(slice, pieces[len(pieces)-1])
	}

	return edge{
		data:      strings.Join(slice, ""),
		frequency: s.cache[value_for(slice)],
	}
}

func is_corner(borders [][]int, cache map[int]int) bool {
	for _, border := range borders {
		sum := 0
		for _, v := range border {
			sum += cache[v]
		}

		if sum == 6 {
			return true
		}
	}

	return false
}

func (s solver) computeBorders(data []string) [][]int {
	// top
	top := strings.Split(data[0], "")

	// bottom
	bottom := strings.Split(data[len(data)-1], "")

	left := []string{}
	right := []string{}
	for _, row := range data {
		left = append(left, string(row[0]))
		right = append(right, string(row[len(row)-1]))
	}

	s.cache[value_for(top)]++
	s.cache[value_for(bottom)]++
	s.cache[value_for(left)]++
	s.cache[value_for(right)]++
	s.cache[value_for(flip(top))]++
	s.cache[value_for(flip(bottom))]++
	s.cache[value_for(flip(left))]++
	s.cache[value_for(flip(right))]++

	return [][]int{
		[]int{value_for(top), value_for(bottom), value_for(left), value_for(right)},
		[]int{value_for(flip(top)), value_for(flip(bottom)), value_for(left), value_for(right)},
		[]int{value_for(top), value_for(bottom), value_for(flip(left)), value_for(flip(right))},
	}
}

func value_for(data []string) int {
	border := 0
	for index, char := range data {
		if char == "." {
			continue
		}

		border += pow(2, index)
	}

	return border
}

func flip(data []string) []string {
	result := make([]string, len(data))

	for i := 0; i < len(data); i++ {
		result[len(data)-1-i] = data[i]
	}

	return result
}

func pow(base, power int) int {
	result := 1
	for i := 0; i < power; i++ {
		result *= base
	}
	return result
}

// pragma mark - private
func parse(input string) []tile {
	result := []tile{}

	for _, chunk := range strings.Split(input, "\n\n") {
		lines := strings.Split(chunk, "\n")

		id, err := strconv.Atoi(strings.Split(strings.Split(lines[0], " ")[1], ":")[0])
		if err != nil {
			panic(err)
		}

		result = append(result, tile{id: id, data: nonempty(lines[1:])})
	}

	return result
}

func nonempty(lines []string) []string {
	result := []string{}

	for _, line := range lines {
		if len(line) == 0 {
			continue
		}

		result = append(result, line)
	}

	return result
}
