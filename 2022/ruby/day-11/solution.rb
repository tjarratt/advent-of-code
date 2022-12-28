#!/usr/bin/env ruby

def part_one
    monkeys = File.read('input')
                  .split("\n\n")
                  .map { parse_monkey(_1) }

    20.times do 
        monkeys.each do |monkey|
            monkey.inspect_relief_decide_throw_loop do |item, index| 
                monkeys[index].receive(item)
            end
        end
    end

    puts monkeys.map(&:inspections)
                .sort
                .last(2)
                .inject(:*)
    # do 20 rounds
    # count the number of times each monkey inspects items
    # take the two most active monkeys
    # multiply their most seen item
end

class Monkey
    attr_reader :inspections

    def initialize(items, operation, test, if_true, if_false)
        @inspections = 0

        @items = items
        @operation = operation
        @test_if_divisible_by = test
        @true_monkey = if_true
        @false_monkey = if_false
    end

    def receive(item)
        @items << item
    end

    def inspect_relief_decide_throw_loop
        # inspect each item and apply @operation
        # worry is divided by three round down
        # test the item if divisible by value
        # throw it to the correct monkey
        @items = @items.map { apply_operation_to(item: _1) }
                       .map { _1 / 3 }
                       .map { [_1, decide_monkey_for(item: _1)] }
                       .each { @inspections += 1 }
                       .each { yield(*_1) }
                       .then { [] }
    end

    private
    def apply_operation_to(item: Number)
        eval(@operation.gsub('old', item.to_s))
    end

    def decide_monkey_for(item: Number)
        item % @test_if_divisible_by == 0 ? @true_monkey : @false_monkey
    end
end

def parse_monkey(block)
    lines = block.split("\n")
    Monkey.new(
        lines[1].split(': ').last.split(', ').map(&:to_i),
        lines[2].split('= ').last,
        lines[3].split(' ').last.to_i,
        lines[4].split(' ').last.to_i,
        lines[5].split(' ').last.to_i
    )
end

part_one
