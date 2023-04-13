#!/usr/bin/env ruby

class Packet
  attr_accessor :data

  def initialize(data)
    @data = data
  end

  def <=>(other)
    in_order?(@data, other.data) ? -1 : 1
    # @data <=> other.data
  end

  def is_divider?
    @data == [[2]] or @data == [[6]]
  end
end

def main
  part_1
  part_2

  exit 0
end

def part_1
    pairs = File.read('input')
                .split("\n\n")
                .map { _1.split("\n").map {|it| eval(it) } }

    puts pairs.each_with_index
              .filter {|pair, index| in_order?(*pair) }
              .map(&:last)
              .map(&:next)
              .inject(:+)
end

def part_2
    packets = File.read('input')
                .split("\n\n")
                .map { _1.split("\n").map {|it| Packet.new(eval(it)) } }
                .flatten(1)

    packets << Packet.new([[2]])
    packets << Packet.new([[6]])

    puts packets.sort
                .each_with_index
                .map { |packet, index| [packet.is_divider?, index] }
                .filter { |packet, index| packet }
                .map { |packet, index| index }
                .map(&:next)
                .inject(:*)
         
end

def in_order?(first, last)
    if first.kind_of? Numeric and last.kind_of? Numeric
        return :continue if first == last
        return first < last
    elsif first.kind_of? Array and last.kind_of? Array
        first.zip(last).each do |a, b|
            return false if b.nil?
            result = in_order?(a, b)
            case result
            when :continue
                next
            else
                return result
            end
        end

        # if first is smaller, they are in perfect order
        if first.size < last.size
          return true
        else
          # in case both are equal, continue comparing
          return :continue
        end
    elsif first.kind_of? Array and last.kind_of? Numeric
        return in_order?(first, [last])
    elsif first.kind_of? Numeric and last.kind_of? Array
        return in_order?([first], last)
    end

    raise "FREAKOUT"
end

main


require 'minitest/autorun'

class TestDetermingOrderOfPacks < MiniTest::Test
  def test_simple
    assert_equal true, in_order?([1,1,3,1,1], [1,1,5,1,1])
    assert_equal true, in_order?([[1],[2,3,4]], [[1],4])
    assert_equal false, in_order?([9], [[8,7,6]])
    assert_equal true, in_order?([[4,4],4,4], [[4,4],4,4,4])
    assert_equal false, in_order?([7,7,7,7], [7,7,7])
    assert_equal true, in_order?([], [3])
    assert_equal false, in_order?([[[]]], [[]])
    assert_equal false, in_order?([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9])
  end
end

