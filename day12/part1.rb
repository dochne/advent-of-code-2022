#!/usr/bin/env ruby

class Grid
    def initialize(cells)
        @width = cells.first.size
        @cells = cells.reduce([]) {_1 + _2}
    end

    def search(start, finish)
        frontier = [start]
        visited = {start => nil}

        while frontier.size > 0
            parent = frontier.shift
            neighbours(parent).each do |index|
                unless visited.has_key?(index)
                    frontier.push(index)
                    visited[index] = parent
                    if index == finish
                        response = []
                        while visited[index] != nil do
                            response << index
                            index = visited[index]
                        end
                        return response
                    end
                end
            end
        end

        nil
    end

    def neighbours(index)
        current_value = @cells[index]
    
        arr = []
        arr << index - 1 if index % @width > 0
        arr << index + 1 if index + 1 % @width < @cells.size
        arr << index - @width if index - @width > 0
        arr << index + @width if index + @width < @cells.size

        arr.filter do |index|
            @cells[index] <= current_value + 1
        end
    end
    
end

input = STDIN.read.lines(chomp: true)
string = input.map(&:chars).reduce([]) {_1 + _2}.join("")
start = string.index("S")
finish = string.index("E")

numbers = input.map(&:chars).map do |row|
    row.map do |cell|
        if cell == "S"
            "a"
        elsif cell == "E"
            "z"
        else
            cell
        end
    end.map{_1.ord - 97}
end


grid = Grid.new(numbers)
path = grid.search(start, finish)
p(path.size)
