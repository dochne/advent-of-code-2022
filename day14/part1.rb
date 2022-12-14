#!/usr/bin/env ruby


grid = {"500,0" => "+"}

value = STDIN.read.lines(chomp: true)
    .each do |line|
        points = line
            .split("->")
            .map(&:strip)
            .map{|v| v.split(",").map(&:to_i)}
            .each_cons(2) do | points |
                Range.new(points.map(&:first).min, points.map(&:first).max).each do |col|
                    Range.new(points.map(&:last).min, points.map(&:last).max).each do |row|
                        grid["#{col},#{row}"] = "#"
                    end
                end
            end
    end


def draw(grid)    
    walls = grid.keys.map{_1.split(",").map(&:to_i)}
    left = walls.map(&:first).min
    right = walls.map(&:first).max
    floor = walls.map(&:last).max

    Range.new(0, floor).each do |row|
        print "#{row} "
        Range.new(left, right).each do |col|
            print(grid["#{col},#{row}"] || ".")
        end
        print("\n")
    end
end

floor = walls = grid.keys.map{_1.split(",")}.map(&:last).map(&:to_i).max

def coord(col, row)
    "#{col},#{row}"
end

while true do
    # drop a piece of sand!
    col = 500
    row = 0
    
    while true do
        if row > floor
            draw(grid)
            p(grid.filter{|_, v| v == "O"}.size)
            exit
        elsif grid[coord(col, row + 1)].nil?
            row += 1     
        elsif grid[coord(col - 1, row + 1)].nil?
            col -= 1
            row += 1
        elsif grid[coord(col + 1, row + 1)].nil?
            col += 1
            row += 1
        else
            grid[coord(col, row)] = "O"
            break
        end
    end
end
# p(grid.keys)

draw(grid)
# p(walls)
