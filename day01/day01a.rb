#!/usr/bin/env ruby

value = STDIN.read.lines("\n\n", chomp: true)
    .map{|items| items.lines(chomp: true).map(&:to_i).sum }
    .max

p(value)