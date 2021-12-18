#!/usr/bin/env ruby

def main
    puts "Testing: Explosions"
    puts explode(parse(eval('[[[[[9,8],1],2],3],4]'), 0))
    puts explode(parse(eval('[7,[6,[5,[4,[3,2]]]]]'), 0))
    puts explode(parse(eval('[[6,[5,[4,[3,2]]]],1]'), 0))
    puts explode(parse(eval('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]'), 0))
    puts explode(parse(eval('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]'), 0))
    puts  

    puts "Testing: Splits"
    puts split(parse(eval('[[[[0,7],4],[15,[0,13]]],[1,1]]'), 0))
    puts

    puts "Testing: reduction"
    puts reduce(parse(eval('[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]'), 0))
    puts

    puts "Testing: Additions"
    puts add(parse_file('test.txt'))
    puts add(parse_file('test-0.txt'))
    puts add(parse_file('test-1.txt'))
    puts add(parse_file('test-2.txt'))
    puts add(parse_file('test-3.txt'))
    puts

    puts "Testing: slightly larger example"
    puts add(parse_file('test-4.txt'))
    puts

    puts "homework solution: #{add(parse_file('homework.txt')).magnitude}"
    puts "part 1 solution: #{add(parse_file('input.txt')).magnitude}"
end

def add(equations)
    result = SnailPair.new(0)
    result.left = equations.slice!(0)
    result.left.parent = result

    result.right = equations.slice!(0)
    result.right.parent = result

    result.rebalance!
    reduce(result)

    equations.each do |equation|
        temp = SnailPair.new(0)
        temp.left = result
        result.parent = temp

        temp.right = equation
        equation.parent = temp

        result = temp
        result.rebalance!
        reduce(result)
    end

    result
end

def parse_file(filename)
    File.read(filename)
        .split("\n")
        .map { eval _1 }
        .map { parse(_1, 0) }
end

def reduce(equation)
    while true
        case what_to_apply?(equation)
        when :explode
            explode(equation)
        when :split
            split(equation)
        else
            return equation
        end
        equation.rebalance!
    end
end

def what_to_apply?(equation)
    visit(equation) do |node|
        return :explode if node.can_explode?
    end

    visit(equation) do |node|
        return :split   if node.splittable?
    end

    return nil
end

def split(equation)
    splitting = nil
    visit(equation) do |node|
        splitting = node
        break if node.splittable?
    end

    half = splitting.value.to_f / 2
    parent = splitting.parent

    left = SnailNumber.new(half.floor, parent.nesting_level + 2)
    right = SnailNumber.new(half.ceil, parent.nesting_level + 2)
    pair = SnailPair.new(parent.nesting_level + 1)
    pair.add_children(left, right)
    pair.parent = parent

    if splitting == parent.left
        parent.left = pair 
    else 
        parent.right = pair
    end

    equation
end

def explode(equation)
    exploding = nil
    visit(equation) do |node|
        exploding = node
        break if node.can_explode?
    end

    parent = exploding.parent

    case left = find_left(exploding)
    when nil
        parent.left = SnailNumber.new(0, parent.nesting_level + 1)
        parent.left.parent = parent
    else 
        left.add(exploding.left.value)
    end
    case right = find_right(exploding)
    when nil
        parent.right = SnailNumber.new(0, parent.nesting_level + 1)
        parent.right.parent = parent
    else
        right.add(exploding.right.value)
    end

    exploding.explode_me()
    equation
end

def find_left(node)
    current = node
    while current.parent.left == current
        current = current.parent 
        return nil if current.parent.nil?
    end

    candidate = current.parent.left
    while candidate.kind_of? SnailPair
        candidate = candidate.right
    end

    candidate
end

def find_right(node)
    current = node
    while current.parent.right == current
        current = current.parent
        return nil if current.parent.nil?
    end

    candidate = current.parent.right
    while candidate.kind_of? SnailPair
        candidate = candidate.left
    end

    candidate
end

def visit(equation, &block)
    block.call(equation)

    if equation.kind_of? SnailNumber
        return
    end

    visit(equation.left, &block)
    visit(equation.right, &block)
end

def dig_right(current)
    while not current.kind_of? SnailNumber
        current = current.right
    end

    current
end

def parse(input, nesting_level)
    return SnailNumber.new(input, nesting_level) if input.kind_of? Integer

    pair = SnailPair.new(nesting_level)

    left = parse(input.first, nesting_level + 1)
    right = parse(input.last, nesting_level + 1)
    pair.add_children(left, right)

    pair
end

class SnailPair
    attr_accessor :parent
    attr_accessor :left
    attr_accessor :right
    attr_accessor :nesting_level

    def initialize(nesting_level)
        @nesting_level = nesting_level
    end

    def add_children(left, right)
        @left = left
        @right = right

        @left.parent = self
        @right.parent = self
    end

    def explode_me
        if parent.left == self
            parent.left = SnailNumber.new(0, parent.nesting_level + 1)
            parent.left.parent = parent
        elsif parent.right == self
            parent.right = SnailNumber.new(0, parent.nesting_level + 1)
            parent.right.parent = parent
        end
    end

    def rebalance!
        @nesting_level = @parent.nesting_level + 1 unless @parent.nil?

        @left.rebalance!
        @right.rebalance!        
    end

    def can_explode?
        return false unless @left.kind_of? SnailNumber and @right.kind_of? SnailNumber

        return @nesting_level == 4
    end

    def splittable?
        false
    end

    def magnitude
        3 * @left.magnitude + 2 * @right.magnitude
    end
    
    def to_s
        "[#{@left},#{@right}]"
    end
end

class SnailNumber
    attr_accessor :parent
    attr_reader :value
    attr_reader :nesting_level

    def initialize(value, nesting_level)
        @value = value
        @nesting_level = nesting_level
    end

    def add(amount)
        @value += amount
    end

    def to_s
        @value.to_s
    end

    def magnitude
        @value
    end

    def can_explode?
        false
    end

    def splittable?
        @value > 9
    end

    def rebalance!
        @nesting_level = @parent.nesting_level + 1
    end
end

main
