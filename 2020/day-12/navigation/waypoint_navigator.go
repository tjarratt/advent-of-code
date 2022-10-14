package navigation

import "fmt"

func WaypointNavigationAssistant(input string) waypointNavigator {
	return waypointNavigator{instructions: parse(input)}
}

type waypointNavigator struct {
	instructions []instruction
}

func (solver waypointNavigator) ManhattanDistance() int {
	location := []int{0, 0}
	waypoint := []int{10, 1}

	for _, instruction := range solver.instructions {
		switch instruction.direction {
		case North:
			waypoint = moveWaypoint(waypoint, North, instruction.quantity)
		case South:
			waypoint = moveWaypoint(waypoint, South, instruction.quantity)
		case East:
			waypoint = moveWaypoint(waypoint, East, instruction.quantity)
		case West:
			waypoint = moveWaypoint(waypoint, West, instruction.quantity)
		case Left:
			waypoint = rotateWaypoint(waypoint, instruction)
		case Right:
			waypoint = rotateWaypoint(waypoint, instruction)
		case Forward:
			location = moveTowards(location, waypoint, instruction.quantity)
		}

		//		println(fmt.Sprintf("instruction %s => %d\n\tlocation: %#v\n\twaypoint: %#v", instruction.direction.String(), instruction.quantity, location, waypoint))
	}

	return abs(location[0]) + abs(location[1])
}

// pragma mark - private

func moveTowards(location, waypoint []int, howMuch int) []int {
	return []int{
		location[0] + waypoint[0]*howMuch,
		location[1] + waypoint[1]*howMuch,
	}
}

func rotateWaypoint(waypoint []int, instruction instruction) []int {
	dir := instruction.direction
	howMuch := instruction.quantity

	if howMuch == 180 {
		return []int{waypoint[0] * -1, waypoint[1] * -1}
	}
	if dir == Left && howMuch == 90 {
		return []int{waypoint[1] * -1, waypoint[0]}
	}
	if dir == Left && howMuch == 270 {
		return []int{waypoint[1], waypoint[0] * -1}
	}
	if dir == Right && howMuch == 90 {
		return []int{waypoint[1], waypoint[0] * -1}
	}
	if dir == Right && howMuch == 270 {
		return []int{waypoint[1] * -1, waypoint[0]}
	}

	panic("unexpected")
}

func moveWaypoint(waypoint []int, direction heading, howMuch int) []int {
	switch direction {
	case North:
		return []int{waypoint[0], waypoint[1] + howMuch}
	case South:
		return []int{waypoint[0], waypoint[1] - howMuch}
	case East:
		return []int{waypoint[0] + howMuch, waypoint[1]}
	case West:
		return []int{waypoint[0] - howMuch, waypoint[1]}
	default:
		panic(fmt.Sprintf("unknown direction %s", direction.String()))
	}
}
