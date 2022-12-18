#!/usr/bin/env ruby

# require 'ruby-prof'
# RubyProf.start

wind = STDIN.read.lines(chomp: true).first

shapes = [
    [
        "..####"
    ],
    [
        "...#.",
        "..###",
        "...#"
    ],
    [
        "....#",
        "....#",
        "..###"
    ],
    [
      "..#",
      "..#",
      "..#",
      "..#"
    ],
    [
        "..##",
        "..##"
    ]
].map do |shape|
    shape.unshift("") while shape.size < 4

    shape
        .map{_1.ljust(7, ".")}
        .map{_1.gsub(".", "0")}
        .map{_1.gsub("#", "1")}
        .map{_1.to_i(2)}.reverse
end


stack = []
shape_i = 0
height = 0
actual = 1_000_000_000_000 

p((10_000_000.to_f / actual.to_f) * 100)
# exit
10_000_000.times do |iter|
    rock = shapes[shape_i % shapes.size]
    shape_i += 1
    pos = height + 3

    while true do
        stack.push(0) while stack.size <= pos
        if (
            pos == 0 ||
            (stack[pos - 1] & rock[0] == 1) ||
            (stack[pos] & rock[1] == 1) ||
            (stack[pos + 1] & rock[2] == 1) ||
            (stack[pos + 2] & rock[3] == 1)
        )
            4.times do |offset|
                stack[pos + offset] = stack[pos + offset] | rock[offset] 
            end
            break
        end
        pos -= 1
    end
end