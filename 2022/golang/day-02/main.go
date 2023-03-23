package main

import (
	"fmt"
	"io"
	"os"
	"strings"
)

func main() {
	score := 0
	for _, round := range readInput("input") {
		score += scoreFor(round)
	}

	println(score)
}

func scoreFor(round Round) int {
	return scoreForShape(round.Player) + scoreForOutcome(round)
}

func scoreForOutcome(round Round) int {
	if round.Opponent == Rock && round.Player == Paper {
		return 6
	}
	if round.Opponent == Paper && round.Player == Scissors {
		return 6
	}
	if round.Opponent == Scissors && round.Player == Rock {
		return 6
	}

	if round.Opponent == round.Player {
		return 3
	}

	return 0
}

func scoreForShape(choice Choice) int {
	switch choice {
	case Rock:
		return 1
	case Paper:
		return 2
	case Scissors:
		return 3
	default:
		panic("unreachable")
	}
}

type Round struct {
	Opponent Choice
	Player Choice
}

type Choice int

const (
	Rock Choice = iota
	Paper
	Scissors
)

func readInput(fileName string) []Round {
	file, _ := os.Open(fileName)
	bytes, _ := io.ReadAll(file)

	result := []Round{}
	for _, line := range strings.Split(string(bytes), "\n") {
		if line == "" {
			continue
		}

		pieces := strings.Split(line, " ")
		opponent := parseChoice(pieces[0])
		player := parseChoice(pieces[1])
		result = append(result, Round{Opponent: opponent, Player: player})
	}

	return result
}

func parseChoice(input string) Choice {
	switch input {
	case "A":
		return Rock
	case "B":
		return Paper
	case "C":
		return Scissors
	case "X":
		return Rock
	case "Y":
		return Paper
	case "Z":
		return Scissors
	}

	panic(fmt.Errorf("could not parse choice (%s)", input))
}
