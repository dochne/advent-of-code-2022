#!/usr/bin/env ruby

require "set"

len = 14

input = STDIN.read.lines(chomp: true).first
value = Range.new(len, input.length).reduce(nil) do | acc, i |
    break i if Set.new(input.slice(i - len, len).chars).length == len
end

p("Value: #{value}")
