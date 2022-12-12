#!/usr/bin/env ruby


start = nil
finish = nil


class Grid
    def initialize(cells, width)
        @cells = cells
        @width = width
    end

    # def traverse(start, finish)
    #     @visited = [start]
    #     @unvisited = Range.new(0, @cells.size).to_a - @visited
    #     @position = start
        

    #     p(routes(position))
    # end

    
    def search
        routes.each do |index|
            next if @visited.include? index


        end
    end

    def routes
        index = @position
        current_value = @cells[index]
    
        arr = []
        arr << index - 1 if index % @width > 0
        arr << index + 1 if index + 1 % @width > 0
        arr << index - @width if index - @width > 0
        arr << index + @width if index + @width < @cells.size
    
        arr.filter do |index|
            @cells[index] <= current_value + 1
        end
    end
    
end

input = STDIN.read.lines(chomp: true)
width = input[0].size

cells = input
    .join("")
    .chars
    .each_with_index do |value, index|
        start = index if value == "S"
        finish = index if value == "E"
    end
    .map do |value|
        if value == "S"
            0
        elsif value == "E"
            25
        else
            value.ord - 97
        end
    end




grid = Grid.new(cells, width)

grid.traverse(start, finish)
# visited = start
# unvisited = 




# p(routes(grid, start, width))


# class Grid
#     def initialize(cells, start, finish)
#         @cells = cells
#         @start = start
#         @finish = finish
#     end


# end


# while unvisited.size > 0
#     x = 
# end