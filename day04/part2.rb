#!/usr/bin/env ruby

value = STDIN.read.lines(chomp: true)
  .map{|pair| pair.split(",").map{|elf| elf.split("-").map(&:to_i)}}
  .map do |pair|
    (pair.map(&:first).max <= pair.map(&:last).min &&
      pair.map(&:last).max >= pair.map(&:first).max) ? 1 : 0
  end
  .sum

p(value)
