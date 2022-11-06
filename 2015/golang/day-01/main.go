package main

import (
    "os"
    "strings"
)

func main() {
    part_one()
    part_two()
}

func part_two() {
    floor := 0
    for index, item := range read_input() {
        if item == "(" {
            floor += 1
        } else if item == ")" {
            floor -= 1
        }

        if floor == -1 {
            println("the solution to part two is : ", index + 1)
            return
        }
    }
}

func part_one() {
    total := 0
    for _, item := range read_input() {
        if item == "(" {
            total += 1
        } else if item == ")" {
            total -= 1
        }
    }

    println("the solution to part one is : ", total)
}

func read_input() []string {
    contents, err := os.ReadFile("input")
    if err != nil {
        panic(err)
    }

    input := string(contents)
    return strings.Split(input, "")
}
