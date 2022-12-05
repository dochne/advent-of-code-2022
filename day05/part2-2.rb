#!/usr/bin/env ruby

data, instructions = STDIN.read.split("\n\n")

cargo = data.split("\n")
    .reduce([]) do |acc, line|
        line.chars.each_with_index {|char, index| acc[index] = (acc[index] || "") + char}
        acc
    end
    .map(&:strip)
    .filter{|line| line.match(/^[A-Z]+\d$/)}

instructions.scan(/move (\d+) from (\d+) to (\d+)/)
    .map{|v| v.map(&:to_i)}
    .each {|total, src, dest| cargo[dest-1] = cargo[src-1].slice!(0, total) + cargo[dest-1] }

value = cargo.map{|v| v[0]}.join("")
p(value)