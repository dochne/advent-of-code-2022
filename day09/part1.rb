#!/usr/bin/env ruby

require "set"

def draw(head, tail, set = nil)
    buffer = []
    5.times.each do | row |
        line = []
        6.times.each do | col |
            if (head[0] === col && head[1] == row)
                line << "H"
            elsif (tail[0] === col && tail[1] == row)
                line << "T"
            elsif set !=nil && set.include?([col, row])
                line << "#"
            else
                line << "."
            end
        end
        buffer << line.join("")
    end
    print(buffer.reverse.join("\n") + "\n\n")
end

array = [
    [[-2, 0], [-1, 0]],
    [[-2, 1], [-1, 0]],
    [[-1, 2], [0, 1]],
    [[0, 2], [0, 1]],
    [[1, 2], [0, 1]],
    [[2, 1], [1, 0]],
    [[2, 0], [1, 0]],
    [[2, -1], [1, 0]],
    [[1, -2], [0, -1]],
    [[0, -2], [0, -1]],
    [[-1, 2], [0, 1]]
]

def move(head, tail)
    h_offset = head[0] - tail[0]
    v_offset = head[1] - tail[1]

    return tail if h_offset.abs <= 1 && v_offset.abs <= 1

    [
        tail[0] + (h_offset != 0 ? (h_offset > 0 ? 1 : -1) : 0),
        tail[1] + (v_offset != 0 ? (v_offset > 0 ? 1 : -1) : 0),
    ]
end

start = [0, 0]
head = start.clone
tail = start.clone
tail_set = Set.new([start])

input = STDIN.read.lines(chomp: true)
    .each do |instruction| 
        instruction.scan(/([UDLR]) (\d+)/) do | direction, distance |
            digit = ["U", "D"].include?(direction) ? 1 : 0
            invert = ["D", "L"].include?(direction) ? -1 : 1

            distance.to_i.times.each do
                head[digit] += invert

                h_offset = head[0] - tail[0]
                v_offset = head[1] - tail[1]

                next if h_offset.abs <= 1 && v_offset.abs <= 1

                tail = [
                    tail[0] + (h_offset != 0 ? (h_offset > 0 ? 1 : -1) : 0),
                    tail[1] + (v_offset != 0 ? (v_offset > 0 ? 1 : -1) : 0),
                ]

                tail_set.add(tail.clone)
            end
        end
    end

p(tail_set.size)
