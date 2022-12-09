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

# array.each do |(tail, expected)|
#     value = move([0, 0], tail)
#     p("#{tail} #{value} #{expected}")
#     if (value != expected)
#         p("Oh no")
#         p(tail)
#         p(expected)
#         exit
#     end
# end


# exit


n = 0
head = [n, n]
tail = [n, n]
tail_set = Set.new()

# if head was 1, 1 and tail was -1, -1

input = STDIN.read.lines(chomp: true)
    .each do |instruction| 
        instruction.scan(/([UDLR]) (\d+)/) do | direction, distance |
            digit = ["U", "D"].include?(direction) ? 1 : 0
            invert = ["D", "L"].include?(direction) ? -1 : 1

            p("#{direction} #{distance}")
            distance.to_i.times.each do
                # raise "negative numbers" if head[0] < 0 || head[1] < 0 || tail[0] < 0 || tail[0] < 0

                # draw(head, tail)

                head[digit] += invert

                h_offset = head[0] - tail[0]
                v_offset = head[1] - tail[1]

                if h_offset == 2 && v_offset == 2
                    p("wtf")
                    exit
                end


                # horizontal = [head[0], tail[0]]
                # vertical = [head[1], tail[1]]
                # h_diff = horizontal.max - horizontal.min
                # v_diff = vertical.max - vertical.min


                
                next if h_offset.abs <= 1 && v_offset.abs <= 1

                tail = [
                    tail[0] + (h_offset != 0 ? (h_offset > 0 ? 1 : -1) : 0),
                    tail[1] + (v_offset != 0 ? (v_offset > 0 ? 1 : -1) : 0),
                ]

                tail_set.add(tail)
                # if h_offset.abs != 0 && v_offset == 0
                #     tail = [tail[0] + (h_offset > 0 ? 1 : -1), tail[1]]
                # end

                # if v_offset.abs != 0 && h_offset == 0
                #     tail = [tail[0], tail[1] + (v_offset > 0 ? 1 : -1)]
                # end


                # draw(head, tail)
                # p("#{h_offset}, #{v_offset}")

                # exit

                # vertical = []

                # if head[0] == tail[0] && 
                
                # if head[0]

                
            end
        end
    end






draw([-1, -1], [-1, -1], tail_set)
p(tail_set.size)
# p(value)

# not 6257 - too high