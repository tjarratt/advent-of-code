package navigation

import (
	"strconv"
	"strings"
)

func NavigationAssistant(input string) solver {
	return solver{instructions: parse(input)}
}

type solver struct {
	instructions []instruction
}

type instruction struct {
	direction heading
	quantity  int
}

type heading int

const (
	North heading = iota
	South
	East
	West
	Left
	Right
	Forward
)

func (s solver) ManhattanDistance() int {
	facing := East
	location := []int{0, 0}

	for _, instruction := range s.instructions {
		switch instruction.direction {
		case North:
			location = moveForward(location, North, instruction.quantity)
		case South:
			location = moveForward(location, South, instruction.quantity)
		case East:
			location = moveForward(location, East, instruction.quantity)
		case West:
			location = moveForward(location, West, instruction.quantity)
		case Left:
			facing = determineFacing(instruction, facing)
		case Right:
			facing = determineFacing(instruction, facing)
		case Forward:
			location = moveForward(location, facing, instruction.quantity)
		}
	}

	return abs(location[0]) + abs(location[1])
}

// pragma mark - private

func abs(i int) int {
	if i < 0 {
		return -i
	} else {
		return i
	}
}

func moveForward(location []int, facing heading, quantity int) []int {
	switch facing {
	case North:
		return []int{location[0], location[1] + quantity}
	case South:
		return []int{location[0], location[1] - quantity}
	case East:
		return []int{location[0] + quantity, location[1]}
	case West:
		return []int{location[0] - quantity, location[1]}
	default:
		panic("unexpected facing")
	}
}

func determineFacing(instruction instruction, facing heading) heading {
	turn := instruction.direction

	switch facing {
	case North:
		if turn == Left {
			switch instruction.quantity {
			case 90:
				return West
			case 180:
				return South
			case 270:
				return East
			default:
				panic("unexpected quantity")
			}
		} else if turn == Right {
			switch instruction.quantity {
			case 90:
				return East
			case 180:
				return South
			case 270:
				return West
			default:
				panic("unexpected quantity")
			}
		} else {
			panic("unexpectetd turn")
		}
	case South:
		if turn == Left {
			switch instruction.quantity {
			case 90:
				return East
			case 180:
				return North
			case 270:
				return West
			default:
				panic("unexpected quantity")
			}
		} else if turn == Right {
			switch instruction.quantity {
			case 90:
				return West
			case 180:
				return North
			case 270:
				return East
			default:
				panic("unexpected quantity")
			}
		} else {
			panic("unexpected turn")
		}
	case East:
		if turn == Left {
			switch instruction.quantity {
			case 90:
				return North
			case 180:
				return West
			case 270:
				return South
			default:
				panic("unexpected quantity")
			}
		} else if turn == Right {
			switch instruction.quantity {
			case 90:
				return South
			case 180:
				return West
			case 270:
				return North
			default:
				panic("unexpected quantity")
			}
		} else {
			panic("unexpected turn")
		}
	case West:
		if turn == Left {
			switch instruction.quantity {
			case 90:
				return South
			case 180:
				return East
			case 270:
				return North
			default:
				panic("unexpected quantity")
			}
		} else if turn == Right {
			switch instruction.quantity {
			case 90:
				return North
			case 180:
				return East
			case 270:
				return South
			default:
				panic("unexpected quantity")
			}
		} else {
			panic("unexpected turn")
		}
	default:
		panic("unexpected facing")
	}
}

func parse(raw string) []instruction {
	instructions := []instruction{}

	for _, line := range strings.Split(raw, "\n") {
		if len(line) == 0 {
			continue
		}

		var heading heading
		switch line[0] {
		case 'N':
			heading = North
		case 'S':
			heading = South
		case 'E':
			heading = East
		case 'W':
			heading = West
		case 'L':
			heading = Left
		case 'R':
			heading = Right
		case 'F':
			heading = Forward
		}

		quantity, err := strconv.Atoi(line[1:])
		if err != nil {
			panic(err)
		}
		instructions = append(instructions, instruction{heading, quantity})
	}

	return instructions
}

func (f heading) String() string {
	switch f {
	case North:
		return "North"
	case South:
		return "South"
	case East:
		return "East"
	case West:
		return "West"
	case Left:
		return "Left"
	case Right:
		return "Right"
	case Forward:
		return "Forward"
	default:
		panic("unknown heading")
	}
}
