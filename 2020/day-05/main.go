package main

import (
	"fmt"
	"io/ioutil"
	"strings"

	. "github.com/tjarratt/advent-of-code-2020/day-05/boarding-passes"
)

func main() {
	max_seat_id := -1
	seating := makeSeating()

	for _, line := range readInput() {
		pass := NewBoardingPass(line)
		seatId := pass.SeatId()
		location := pass.Location()

		seating[location.Row][location.Column] = pass

		if seatId > max_seat_id {
			max_seat_id = seatId
		}
	}

	println("Highest seat id is", max_seat_id)
	println()

	firstCompleteRow := -1
	for i := 0; i < len(seating) && firstCompleteRow == -1; i++ {
		for j := 0; j < len(seating[i]); j++ {
			if isComplete(seating[i]) {
				firstCompleteRow = i
				break
			}
		}
	}

	for i := firstCompleteRow; i < len(seating); i++ {
		for j := 0; j < len(seating[i]); j++ {
			if seating[i][j].IsEmpty() {
				println("Your seat id is", i*8+j)
				return
			}
		}
	}
}

func printSeating(seating [][]BoardingPass) {
	for i := 0; i < len(seating); i++ {
		for j := 0; j < len(seating[i]); j++ {
			fmt.Printf(seating[i][j].String())
		}

		println("", i)
	}
}

func isComplete(row []BoardingPass) bool {
	for i := 0; i < len(row); i++ {
		if row[i].IsEmpty() {
			return false
		}
	}

	return true
}

func makeSeating() [][]BoardingPass {
	seating := make([][]BoardingPass, 128)
	for i := 0; i < 128; i++ {
		seating[i] = make([]BoardingPass, 8)
	}

	return seating
}
func readInput() []string {
	stuff, err := ioutil.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(stuff), "\n")

	return lines[:len(lines)-1]
}
