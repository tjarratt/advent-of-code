//
//  main.swift
//  day-02
//
//  Created by Tim Jarratt and Wiley Kestern on 20/11/2022.
//

import Foundation

func compute(instructions: Array<Int>) -> Array<Int> {
    var instructionPointer = 0
    var opCode = instructions[instructionPointer]
    var output = instructions
    
    while (opCode != 99) {
        let addendIndex = output[instructionPointer + 1]
        let augendIndex = output[instructionPointer + 2]
        let resultIndex = output[instructionPointer + 3]
        
        if opCode == 1 {
            output[resultIndex] = output[addendIndex] + output[augendIndex]
        } else {
            output[resultIndex] = output[addendIndex] * output[augendIndex]
        }
        
        instructionPointer += 4
        opCode = output[instructionPointer]
    }
    
    return output
}

func test(_ actual: Array<Int>, _ expected: Array<Int> ) {
    let result = (actual == expected) ? "PASS": "FAIL"
    print("\(result): Actual: \(actual)\tExpected: \(expected)")
}

test(compute(instructions: [1,0,0,0,99]), [2,0,0,0,99])
test(compute(instructions: [1,2,2,0,99]), [4,2,2,0,99])
test(compute(instructions: [1,1,2,0,99]), [3,1,2,0,99])
test(compute(instructions: [1,4,4,5,99,0]), [1,4,4,5,99,198])
test(compute(instructions: [2,3,0,3,99]), [2,3,0,6,99])
test(compute(instructions: [2,4,4,5,99,0]), [2,4,4,5,99,9801])
test(compute(instructions: [1,1,1,4,99,5,6,0,99]), [30,1,1,4,2,5,6,0,99])

func main() {
    var input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,10,19,23,1,6,23,27,1,5,27,31,1,10,31,35,2,10,35,39,1,39,5,43,2,43,6,47,2,9,47,51,1,51,5,55,1,5,55,59,2,10,59,63,1,5,63,67,1,67,10,71,2,6,71,75,2,6,75,79,1,5,79,83,2,6,83,87,2,13,87,91,1,91,6,95,2,13,95,99,1,99,5,103,2,103,10,107,1,9,107,111,1,111,6,115,1,115,2,119,1,119,10,0,99,2,14,0,0
    ]
    input[1] = 12
    input[2] = 2
    print("... but will it blend ?", compute(instructions: input)[0])
}

main()
