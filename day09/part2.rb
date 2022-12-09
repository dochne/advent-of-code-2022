#!/usr/bin/env ruby

require "set"

def cell_value(rope, col, row)
    rope.each.with_index do |knot, index|
        next if knot != [col, row]
        return "H" if index == 0
        return index
    end
    return "."
end

def draw(rope, tail_set = nil)
    buffer = []
    21.times.each do | row |
        line = []
        26.times.each do | col |
            if tail_set != nil && tail_set.include?([col, row])
                line << "#"
            else
                line << cell_value(rope, col, row)
            end
        end
        buffer << line.join("")
    end
    print(buffer.reverse.join("\n") + "\n\n")
end

start = [0, 0]
rope = Array.new(10, start).map(&:clone)

tail_set = Set.new([start])

input = STDIN.read.lines(chomp: true)
    .each do |instruction| 
        instruction.scan(/([UDLR]) (\d+)/) do | direction, distance |
            digit = ["U", "D"].include?(direction) ? 1 : 0
            invert = ["D", "L"].include?(direction) ? -1 : 1

            distance.to_i.times.each do
                rope[0][digit] += invert

                rope.each_with_index do |knot, index|
                    next if index == 0

                    parent = rope[index - 1]
                    h_offset = parent[0] - knot[0]
                    v_offset = parent[1] - knot[1]

                    next if h_offset.abs <= 1 && v_offset.abs <= 1

                    rope[index] = [
                        knot[0] + (h_offset != 0 ? (h_offset > 0 ? 1 : -1) : 0),
                        knot[1] + (v_offset != 0 ? (v_offset > 0 ? 1 : -1) : 0),
                    ]

                    if index == rope.size - 1
                        tail_set.add(rope[index])
                    end
                end
            end
        end
    end

p(tail_set.size)