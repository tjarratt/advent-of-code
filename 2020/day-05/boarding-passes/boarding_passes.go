package boarding_passes

import (
	"fmt"
	"math"
	"strings"
)

type Seat struct {
	Row    int
	Column int
}

type BoardingPass struct {
	raw string
}

func NewBoardingPass(input string) BoardingPass {
	return BoardingPass{raw: input}
}

func (pass BoardingPass) Location() Seat {
	return Seat{
		Row:    parseRow(pass.raw[0:7]),
		Column: parseColumn(pass.raw[7:10]),
	}
}

func (pass BoardingPass) SeatId() int {
	loc := pass.Location()

	return loc.Row*8 + loc.Column
}

func (pass BoardingPass) IsEmpty() bool {
	return pass.raw == ""
}

func (pass BoardingPass) String() string {
	if pass.IsEmpty() {
		return "."
	} else {
		return "x"
	}
}

// pragma mark - private
func parseRow(commands string) int {
	min := 0
	max := 127
	mid := 0

	for _, cmd := range strings.Split(commands, "") {
		switch cmd {
		case "B": // upper
			mid = int(math.Ceil(float64(min+max) / 2.0))
			min = mid
		case "F": // lower
			mid = int(math.Floor(float64(min+max) / 2.0))
			max = mid
		default:
			panic(fmt.Sprintf("unknown row command '%s'", cmd))
		}
	}

	return mid
}

func parseColumn(commands string) int {
	min := 0
	max := 7
	mid := 0

	for _, cmd := range strings.Split(commands, "") {
		switch cmd {
		case "L": // lower half
			mid = int(math.Floor(float64(min+max) / 2.0))
			max = mid

		case "R": // upper half
			mid = int(math.Ceil(float64(min+max) / 2.0))
			min = mid

		default:
			panic(fmt.Sprintf("unknown column command '%s'", cmd))
		}
	}

	return int(mid)
}
