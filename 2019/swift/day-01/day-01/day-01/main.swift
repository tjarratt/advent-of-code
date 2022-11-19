//
//  main.swift
//  day-01
//

import Foundation

func main() {
    part_one()
}

func part_one() {
    let input = read(filename: "input")
    
    let sum = input.map { mass in
        calculateFuelFor(mass: mass)
    }.reduce(0, { accum, fuel in
        accum + fuel
    })
    
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
