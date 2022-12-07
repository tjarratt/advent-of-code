#!/usr/bin/env ruby

def part_one
    tree = FunctionalTree.new
    output = File.read('input')
                 .split("\n")
                 .filter { _1.match(/\$ ls/).nil? }
                 .each do |line|
                     case line
                     when '$ cd ..'
                        tree.pop
                     when /\$ cd (.+)/
                        tree.push(line.split(' ').last)
                     when /([0-9]+) (.+)/
                        bytes, filename = line.split(' ')
                        tree.set(filename, bytes)
                     end
                  end

    puts tree.directories_and_sizes
             .filter {|name, size| size <= 100000 }
             .map(&:last)
             .inject(:+)
end

def part_two
    tree = FunctionalTree.new
    output = File.read('input')
                 .split("\n")
                 .filter { _1.match(/\$ ls/).nil? }
                 .each do |line|
                    case line
                    when '$ cd ..'
                        tree.pop
                    when /\$ cd (.+)/
                        tree.push(line.split(' ').last)
                    when /([0-9]+) (.+)/
                        bytes, filename = line.split(' ')
                        tree.set(filename, bytes)
                    end
                 end

    total = 70000000
    needs = 30000000
    used  = tree.directories_and_sizes.first.last
    find  = needs - (total - used)
    puts tree.directories_and_sizes
             .filter {|name, size| size >= find }
             .map(&:last)
             .sort
             .first
end

class Node

  attr_reader :key, :value

  def initialize(key, value)
    @key = key
    @value = value
  end

  def size
    @value.to_i
  end
end

class FunctionalTree
  def initialize
    @root = Tree.new
    @current = @root
  end

  def push(key)
    @current = @current.push(key)
  end

  def pop
    @current = @current.parent
  end

  def set(key, value)
    @current.set(key, value)
  end

  def directories_and_sizes
    # visit each sub-tree
    # ask it its size and key

    results = []
    root_tree = @root.nodes.first

    walk(@root.nodes.first) do |tree|
      results << [tree.key, tree.size]
    end

    results
  end

  def walk(tree, &block)
    block.call tree

    tree.nodes.each do |node|
        next if node.kind_of? Node

        walk(node, &block)
    end
  end
end

class Tree
  attr_reader :parent, :nodes, :key

  def initialize(key=nil, parent=nil)
    @key = key
    @nodes = []
    @parent = parent
  end

  def push(key)
    node = Tree.new(key, self)
    @nodes.push << node

    node 
  end

  def set(key, value)
    @nodes.push Node.new(key, value)
  end

  def size
    @nodes.map(&:size).inject(&:+)
  end
end

part_one
part_two

