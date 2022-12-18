#!/usr/bin/env ruby

require "set"

$blocks = STDIN.read.lines(chomp: true)
    .map{_1.split(",").map(&:to_i)}

$bounds = $blocks.reduce({x: [], y: [], z: []}) do |acc, (x, y, z)|
    acc[:x] << x
    acc[:y] << y
    acc[:z] << z
    acc
end.map{|key, value| [key, Range.new(*value.minmax)]}.to_h

# $memory = {}

# def memoize(key, &block)
#     if $memory[key].nil?
#         $memory[key] = yield
#     end
#     $memory[key]
# end

#272 too low
$cache = {}

def memoize(key, &block)
    if $cache[key].nil?
        $cache[key] = yield
    end
    $cache[key]
end


def escape?(cell)
    memoize(cell) do
        # if we're escaping, there's 6 ways we can potentially go!
        
        return false if $blocks.include?(cell)

        # if !$bounds[:x].cover?(cell[0]) || !$bounds[:y].cover?(cell[1])
        #     # p("#{cell} Already out before we begin!")
        #     return true
        # end


        frontier = [cell]
        fill = []
        visited = {}
        

        
        while frontier.size > 0
            current_cell = frontier.shift

            x, y, z = current_cell

            dir = []
            [-1, 1].each do |offset|
                dir.push([x + offset, y, z], [x, y + offset, z], [x, y, z + offset])
            end

            dir.each do |new_cell|
                unless visited.has_key?(new_cell)
                    visited[new_cell] = 1
                    
                    next if $blocks.include?(new_cell)

                    # $cache[cell] ||
                    if  !$bounds[:x].cover?(new_cell[0]) || !$bounds[:y].cover?(new_cell[1]) || !$bounds[:z].cover?(new_cell[2])
                        # end condition! we're free!
                        # fill.each do |cell|
                        #     $cache[cell] = true
                        # end

                        if cell == [2, 2, 5]
                            p("Yay, i left")
                        end

                        return true
                    end

                    # unless 
                    #     fill.push(new_cell)
                    #     frontier.push(new_cell)
                    # end
                end
            end
        end

        if cell == [2, 2, 5]
            p("Oh no, I didn't")
        end

        false
    end
end


# These are all the *blocks* that surfaces could face
# surface_blocks = $blocks.reduce(Set.new) do |acc, (x, y, z)|
#     [
#         [x, y, z],
#         [x, y, z + 1],

#         [x, y, z],
#         [x + 1, y, z],

#         [x, y, z],
#         [x, y + 1, z]
#     ].each{|line| acc.add(line)}
#     acc
# end

# valid_blocks = surface_blocks.filter do |cell| 
#     escape?(cell)
# end


# p(valid_blocks.size)

def edge_can_escape?(edge)
    x, y, z = edge.slice(1, 3)
    edge_blocks = if edge[0] == :F
        [
            [x, y, z],
            [x, y, z - 1]
        ]
    elsif edge[0] == :S
        [
            [x, y, z],
            [x - 1, y, z]
        ]
    elsif edge[0] == :T
        [
            [x, y, z],
            [x, y - 1, z]
        ]
    end

    edge_blocks.any?{|cell| escape?(cell)}
end

surfaces = $blocks
    .reduce(Set.new) do |acc, (x, y, z)|
        [
            [:F, x, y, z],
            [:F, x, y, z + 1],
    
            [:S, x, y, z],
            [:S, x + 1, y, z],
    
            [:T, x, y, z],
            [:T, x, y + 1, z]
        ].each do | edge |
            next unless edge_can_escape?(edge)
            # next unless valid_blocks.include?(array.slice(1, 3))

            if acc.add?(edge).nil?
                acc.delete(edge)
            end
        end

        acc
    end

p(surfaces.size)