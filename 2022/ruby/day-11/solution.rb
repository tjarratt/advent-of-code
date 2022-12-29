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

def part_two
    monkeys = File.read('input')
                  .split("\n\n")
                  .map { parse_monkey(_1) }

    lcm = monkeys.map(&:test_if_divisible_by).inject(:*)
    monkeys.each { _1.divisor = lcm }

    10000.times do |i|
        monkeys.each do |monkey|
            monkey.inspect_decide_throw do |item, index|
                raise 'FREAKOUT' if index >= monkeys.size
                monkeys[index].receive(item)
            end
        end
    end

    puts monkeys.map(&:inspections).sort.last(2).inject(:*)
end

class MonkeyWithATimer
    def initialize(monkey)
        @delegate = monkey
    end

    def method_missing(m, *args, &block)
        start = Time.now
        result = @delegate.send(m, *args, &block)
        finish = Time.now
        puts "Resolved #{m} in #{finish - start} seconds"

        result
    end
end

class Monkey
    attr_reader :inspections, :test_if_divisible_by
    attr_accessor :divisor

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
                       .tap { @inspections += _1.size }
                       .each { yield(*_1) }
                       .then { [] }
    end

    def inspect_decide_throw
        @items = @items.map { apply_operation_to(item: _1) }
                       .map { _1 % @divisor }
                       .map { [_1, decide_monkey_for(item: _1)] }
                       .tap { @inspections += _1.size }
                       .each { yield(*_1) }
                       .then { [] }

    end

    private
    def apply_operation_to(item: Number)
        @operation.call(item)
    end

    def decide_monkey_for(item: Number)
        item % @test_if_divisible_by == 0 ? @true_monkey : @false_monkey
    end
end

def parse_monkey(block)
    lines = block.split("\n")
    Monkey.new(
        lines[1].split(': ').last.split(', ').map(&:to_i),
        parse_operation(expression: lines[2].split('= ').last),
        lines[3].split(' ').last.to_i,
        lines[4].split(' ').last.to_i,
        lines[5].split(' ').last.to_i
    )
end

def parse_operation(expression: String)
    tokens = expression.split(' ')
    case tokens
    in ['old', '*', 'old']
        return Proc.new { _1 ** 2 }
    in ['old', '+', String]
        return Proc.new { _1 + tokens.last.to_i }
    in ['old', '*', String]
        return Proc.new { _1 * tokens.last.to_i }
    end
end

part_one
part_two
