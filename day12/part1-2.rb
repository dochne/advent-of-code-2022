#!/usr/bin/env ruby

require "matrix"

input = STDIN.read.lines(chomp: true)
    .map(&:chars)
    .each_with_index.reduce({}) do | acc, (chars, row_i) |
        chars.each_with_index do |char, col_i|
            acc["#{row_i},#{col_i}"] = char
        end
        acc
    end

offsets = Matrix.build(2, 2).to_a.map{|d| d.map{_1 == 1 ? -1 : 1}}
start = input.key("S")
finish = input.key("E")

frontier = [start]
visited = {start => nil}

while frontier.size > 0
    parent_key = frontier.shift
    p(parent_key)
    neighbours = [parent_key]
        .map do |key|
            coords = key.split(",").map(&:to_i)
            offsets.map do
                [_1 + coords[0], _2 + coords[1]]
            end
        end
        .first
        .map{|v| v.join(",")}
        .filter{input.has_key?(_1)}
        .filter() # we also would need to filter ords
        # .filter{!visited.has_key?(_1)}
        
    neighbours.each do |index|
        next if visited.has_key?(index)

        frontier.push(index)
        visited[index] = parent_key
        if index == finish
            response = []
            while visited[index] != nil do
                response << index
                index = visited[index]
            end
            p(response)
            exit
        end
    end
end
