//
//  main.swift
//  day-01
//

import Foundation

func main() {
    part_one()
    part_two()
}

func part_one() {
    let input = read(filename: "input")
    
    let sum = input.map { mass in
        calculateFuelFor(mass: mass)
    }.reduce(0, { accum, fuel in
        accum + fuel
    })
    
    print("part one is", sum)
}

func part_two() {
    let input = read(filename: "input")
    
    let sum = input.map { mass in
        calculateFuelForRecursively(mass: mass)
    }.reduce(0, { accum, fuel in
        accum + fuel
    })
    
    print("part two is", sum)
}

func calculateFuelFor(mass: Int) -> Int {
    return mass / 3 - 2
}

func calculateFuelForRecursively(mass: Int) -> Int {
    var sum = 0
    var fuel = calculateFuelFor(mass: mass)
    
    while fuel > 0 {
        sum += fuel
        fuel = calculateFuelFor(mass: fuel)
    }
    
    return sum
}

func read(filename: String) -> Array<Int> {
    return try! String(contentsOfFile: filename, encoding: .utf8)
        .components(separatedBy: "\n")
        .filter { !$0.isEmpty }
        .map { try! Int($0, format: .number) }
}

main()
