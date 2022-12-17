#!/usr/bin/env ruby

# require 'ruby-prof'
# RubyProf.start

wind = STDIN.read.lines(chomp: true).first

# def output(space)
#     space.reverse_each do |line|
#         value = line.to_s(2)
#             .rjust(7, "0")
#             .gsub("1", "@")
#             .gsub("0", ".")

#         print("|#{value}|\n")
#     end

#     print("+-------+\n")
# end

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

# space = []

class Shape
    def initialize(rows)
        @rows = rows
    end

    def collision(pos)

    end

    def collide
        return (
            pos > 0 || (
                (@rows[pos] || 0) & shape[0] != 0 ||
                (@rows[pos + 1] || 0) & shape[1] != 0 ||
                (@rows[pos + 2] || 0) & shape[2] != 0 ||
                (@rows[pos + 3] || 0) & shape[3] != 0
            )
        )

        if @rows.all?{|line| line & 1 == 0}
            @rows.map{_1 >> 1}
        end
    end

    def apply

    end

end

hit_map = {}
128.times do |index|
    hit_map[index] = index.to_s(2).chars.filter{|v| v == "1"}.size
end


class Rows
    def initialize
        @rows = []
    end

    def repeat
        joined = @rows.join(",")

        last_ten = @rows.slice(height - 10, 10).join(",")

        index = joined.index(last_ten)

        p("found index #{index} height #{height - 10}")

        

    end
    
    def height
        # @rows.filter{|v| v!= 0}.size

        @rows.reverse_each.with_index do |row, idx|
            return @rows.size - idx if row != 0
        end

        0

        # @rows.reverse_each.with_index do |row, idx|
        #     if row != 0
        #         p("Indexxx #{@rows} #{idx}")
        #     end
        #     return idx if row != 0
        # end

        # 0
    end

    def add(shape, pos)
        # if pos > @rows.size
        #     (pos - @rows.size).times.each{@rows.push(0)}
        # end

        shape.each_with_index do |row, idx|
            @rows[pos + idx] = (@rows[pos + idx] || 0) | row
        end
    end

    def remove(shape, pos)
        shape.each_with_index do |row, idx|
            @rows[pos + idx] = (@rows[pos + idx] || 0) ^ row
        end
    end

    def collide(shape, pos)

        return (
            pos < 0 || (
                (@rows[pos] || 0) & shape[0] != 0 ||
                (@rows[pos + 1] || 0) & shape[1] != 0 ||
                (@rows[pos + 2] || 0) & shape[2] != 0 ||
                (@rows[pos + 3] || 0) & shape[3] != 0
            )
        )


        return true if pos < 0
        # p("#{pos}")

        shape.each_with_index.any? do |row, idx|
            row_idx = pos + idx
            # before = hit_map[@rows[row_idx] || 0]

            # Do we get anything where both before and after were flagged? If so, collision!
            # after_and = hit_map[(@rows[row_idx] || 0) & row]

            # If *everything* is highlighted in this, do 
            # after_or = hit_map[(@rows[row_idx] || 0) | row]

            # before.nil? || after.nil? || before != after

            # after.nil? || 
            # (@rows[row_idx] || 0) & row
            (@rows[row_idx] || 0) & row != 0

            # log("Collision detected at #{@rows[row_idx]} #{pos} #{idx} #{row} #{resp}") if resp

            # resp
        end 
    end

    def display
        @rows.map{|v| v.to_s(2).rjust(7, "0")}.reverse_each.with_index do |line, idx|

            line = line
                .gsub("1", "@")
                .gsub("0", ".")

            print("#{(@rows.size - idx - 1).to_s.rjust(3)} |#{line}|\n")
            
        end

        print("    +-------+\n")
    end
end


rows = Rows.new

# rows.add(2, [30, 41])
# # rows.remove(2, [0, 1])


# rows.display
# exit




class Grid 
    def initialize(shapes, wind)
        @rows = Rows.new
        @shapes = shapes
        @shape_idx = 0
        @wind = wind
        @wind_idx = 0
    end

    def log(message)
        print("#{message}\n")
        # @rows.display
    end
        
    def drop
        shape = next_shape
        # position = @rows.filter{|v| v!=0}.size + 4
        position = @rows.height + 3

        # p(@rows)
        # log("Dropping new rock")
        # @rows.add(shape, position)
        # @rows.display
        # exit

        while true do
            wind = next_wind

            # We immediately remove the shape! Bwahahaha!
            # @rows.remove(shape, position)

            
            # Then we check the wind - if we moved to the right, would we be okay?
            if wind == ">"
                # log("Attempting to move right")
                if !shape.any?{|line| line & 1 != 0} 
                # if !((shape[0] & 1 !=0) || (shape[1] & 1 !=0) || (shape[2] & 1 !=0) || (shape[3] & 1 !=0))
                    # we can only move right if there's nothing in the far right!
                    # but first, will we collide with something if we do this?
                    collide_shape = shape.map{_1 >> 1}
                    if !@rows.collide(collide_shape, position)
                        # log("Successfully moved right")
                        # if there's no collision, we can move!
                        shape = collide_shape
                    end
                end
            else
                # log("Attempting to move left")
                if !shape.any?{|line| line & 64 != 0} 
                # if !((shape[0] & 64 !=0) || (shape[1] & 64 !=0) || (shape[2] & 64 !=0) || (shape[3] & 64 !=0))
                    # we can only move right if there's nothing in the far left!
                    # but first, will we collide with something if we do this?
                    collide_shape = shape.map{_1 << 1}
                    if !@rows.collide(collide_shape, position)
                        # log("Successfully moved left")
                        # if there's no collision, we can move!
                        shape = collide_shape
                    end
                end
            end

            # log("Attempting to move down")
            
            # now, will we collide when if move down?

            if !@rows.collide(shape, position - 1)
                # p("No collision, descending #{position}")
                # No? Then move down we shall!

                # log("Moving down")

                position -= 1
                # @rows.add(shape, position)

                # @rows.display
            else
                # we will collide? Then I guess this shape has come to rest!
                # log("Collision moving down, placing block")
                @rows.add(shape, position)
                return
            end
        end
    end

    def next_wind
        wind = @wind[@wind_idx % @wind.size]
        @wind_idx += 1
        wind
    end


    def next_shape
        shape = @shapes[@shape_idx % @shapes.size]
        @shape_idx += 1
        shape
    end

    def begin(iter)
        @shape_idx = 0
        @wind_idx = 0
        # @rows = []
        iter.times.each do |time|
            if time % 1_000_000 == 0
                p("#{time} / #{(time.to_f / 1000000000000.0) * 100}%")
            end
            drop
        end

        p(@rows.height)
        # @rows.display
    end
end


grid = Grid.new(shapes, wind.chars)
grid.begin(10000)
