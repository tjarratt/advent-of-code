//
//  main.swift
//  day-01
//

import Foundation

func main() {
    print("Hello Advent of Code 2019")
    
    let input = read(filename: "input")
    var sum = 0
    input.forEach { mass in
        let fuel = calculateFuelFor(mass: mass)
        sum += fuel
    }
    
    print(sum)
}

func calculateFuelFor(mass: Int) -> Int {
    return mass / 3 - 2
}

func read(filename: String) -> Array<Int> {
    var list = Array<Int>()
    
    let contents = try! String(contentsOfFile: filename, encoding: .utf8)
    
    contents.enumerateLines { line, _ in
        let mass = try! Int(line, format: IntegerFormatStyle.number)
        list.append(mass)
    }
    
    return list
}

main()
