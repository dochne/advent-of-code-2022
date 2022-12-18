#!/usr/bin/env ruby

require "set"

$blocks = [
    [1, 1],
    [1, 2],
    [1, 3],
    [2, 1],
    # [2, 2],
    # [2, 3],
    [3, 1],
    [3, 2],
    [3, 3],
    [4, 1],
    [4, 2],
    [4, 3],
]

$bounds = $blocks.reduce({x: [], y: []}) do |acc, (x, y)|
    acc[:x] << x
    acc[:y] << y
    acc
end.map do |key, value|
    # minmax = value.minmax
    # If something *is* the highest x or y, then they're already free!
    # [key, Range.new(minmax[0] + 1, minmax[1] - 1)]
    [key, Range.new(*value.minmax)]
end.to_h


$cache = {}

def escape?(cell)

    return false if $blocks.include?(cell)

    if !$bounds[:x].cover?(cell[0]) || !$bounds[:y].cover?(cell[1])
        # p("#{cell} Already out before we begin!")
        return true
    end

    # p("Attempting to escape from #{cell}")
    # if we're escaping, there's 6 ways we can potentially go!
    
    frontier = [cell]
    fill = []
    visited = {}


    while frontier.size > 0
        current_cell = frontier.shift

        x, y = current_cell

        dir = []
        [-1, 1].each do |offset|
            dir.push([x + offset, y], [x, y + offset])
        end

        dir.each do |new_cell|
            unless visited.has_key?(new_cell)
                visited[new_cell] = 1
                
                next if $blocks.include?(new_cell)


                # $cache[cell] ||
                if  !$bounds[:x].cover?(new_cell[0]) || !$bounds[:y].cover?(new_cell[1])
                    # p("#{cell} via #{new_cell} found a route to the surface!")
                    # end condition! we're free!
                    # fill.each do |cell|
                    #     $cache[cell] = true
                    # end
                    return true
                end

                # unless $blocks.include?(new_cell)
                fill.push(new_cell)
                frontier.push(new_cell)
                # end
            end
        end
    end

    p("#{cell} failed to find a route to the surface")
    false
end


# p("#{escape?([2, 3])}")
# exit
# These represent blocks that are faced by each surface 
faced_blocks = $blocks.reduce(Set.new) do |acc, (x, y)|
    [
        [x + 1, y],
        [x, y + 1]   
    ].each{|line| acc.add(line)}
    acc
end

# valid_blocks = faced_blocks.filter{|block| escape?(block)}
# We're only interested in blocks that are "open" to the world
# So for each of the blocks faced, we want to see if there's a route for it
# To get to the surface



surfaces = $blocks
    .reduce(Hash.new) do |acc, (x, y)|
        # p ("Dealing with block at #{x}, #{y}")
        result = [
            # a block has a surface on both the top and bottom
            ["S", x, y],
            ["S", x + 1, y],

            ["T", x, y],
            ["T", x, y + 1]
        ]
        
        # p(result)
        
        result.each do |array|
            # we probably don't want to do this ahead of time
            facing = if array[0] == "T"
                [
                    [array[1], array[2] - 1],
                    [array[1], array[2]],
                ]
            elsif array[0] == "S"
                [
                    [array[1] - 1, array[2]],
                    [array[1], array[2]]
                ]
            end

            # p(facing)
            if !escape?(facing[0]) && !escape?(facing[1])
            # if !valid_blocks.include?(array.slice(1, 2))
                # p("Skipping surface #{array} inside #{x}, #{y}")
                next
            end

            acc[array] = (acc[array] || 0) + 1 
            # if acc.add?(array).nil?
            #     p("Removing #{array}")
            #     acc.delete(array)
            # else
            #     p("Adding #{array}")
            # end
        end

        acc
    end

result = surfaces.filter{|idx, v| v == 1}
surfaces = result.keys
# p(result.keys)
p(result.size)
p(surfaces.sort.each{|v| p(v)})
p(surfaces.size)

exit


# p(surface_blocks)
# exit

# valid_blocks = surface_blocks.filter do |cell| 
#     escape?(cell)
# end


# p(valid_blocks.size)


# surfaces = $blocks
#     .reduce(Set.new) do |acc, (x, y, z)|
#         [
#             ["F", x, y, z],
#             ["F", x, y, z + 1],
    
#             ["S", x, y, z],
#             ["S", x + 1, y, z],
    
#             ["T", x, y, z],
#             ["T", x, y + 1, z]
#         ].each do |array|
#             next unless valid_blocks.include?(array.slice(1, 3))

#             p
#             if acc.add?(array).nil?
#                 p("emoving #{array}")
#                 acc.delete(array)
#             end
#         end

#         acc
#     end


# p(surfaces.size)