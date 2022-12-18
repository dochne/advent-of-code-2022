#!/usr/bin/env ruby

require "set"

value = STDIN.read.lines(chomp: true)
    .map{_1.split(",").map(&:to_i)}
    .reduce(Set.new) do |acc, (x, y, z)|
        # p(x)

        [
            ["F", x, y, z],
            ["F", x, y, z + 1],
    
            ["S", x, y, z],
            ["S", x + 1, y, z],
    
            ["T", x, y, z],
            ["T", x, y + 1, z]
        ].each do |array|
            if acc.add?(array).nil?
                acc.delete(array)
            end
        end

        
        acc
    end

    # p(value)
p(value.size)
