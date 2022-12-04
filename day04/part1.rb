#!/usr/bin/env ruby

value = STDIN.read.lines(chomp: true)
  .map{|pair| pair.split(",").map{|elf| elf.split("-").map(&:to_i)}}
  .reduce 0 do |acc, pair|
    next acc + 1 if pair[0][0] >= pair[1][0] && pair[0][1] <= pair[1][1]
    next acc + 1 if pair[1][0] >= pair[0][0] && pair[1][1] <= pair[0][1]
    acc
  end

p(value)
