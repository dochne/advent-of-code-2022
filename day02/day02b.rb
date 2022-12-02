#!/usr/bin/env ruby

value = STDIN.read.lines(chomp: true)
    .reduce(0) do |acc, match|
        played, result = match.split(" ").map{|char| char.ord % 87 % 64}
        offset = (played + result - 2 + 3) % 3
        score = (result - 1) * 3
        (offset == 0 ? 3 : offset) + score + acc
    end
p(value)