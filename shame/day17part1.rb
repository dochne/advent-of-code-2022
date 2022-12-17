#!/usr/bin/env ruby

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
    shape
        .map{_1.ljust(7, ".")}
        .map{_1.gsub(".", "0")}
        .map{_1.gsub("#", "1")}
        .map{_1.to_i(2)}
end

# space = []

# class Shape
#     def initialize(strings)
#         @values = strings
#             .map{_1.ljust(7, ".")}
#             .map{_1.gsub(".", "0")}
#             .map{_1.gsub("#", "1")}
#             .map{_1.to_i(2)}
#     end

#     def move_left

#     end

#     def move_right

#     end
# end

class Grid 
    def initialize(shapes, wind)
        @rows = []
        @shapes = shapes
        @shape_idx = 0
        @wind = wind
        @wind_idx = 0
    end

    def drop
        shape = next_shape

        shape_pos = (@rows.size + 4) + shape.size

        p("Rock is falling!")
        while true do
            wind = next_wind
            p("Wind #{wind}")
            shape = if wind == ">"
                if shape.all?{|line| line & 1 == 0}
                    p("Moving right")
                    shape.map{_1 >> 1}
                else
                    p("Can't move right")
                    shape
                end
            elsif shape.all?{|line| line & 64 == 0}
                p("moving left")
                shape.map{_1 << 1}
            else
                shape
            end

            shape_pos -= 1


            if collision(shape, shape_pos)
                p("Collisino detected!")

                p("Rows")
                p(@rows)


                shape.each.with_index do |line, idx|
                    # p("idx shape #{shape} #{idx} #{shape_pos} #{line}")
                    @rows[idx + shape_pos] = (@rows[idx + shape_pos] || 0) & line
                end


                p("Rows")
                p(@rows)

                display

                exit
            end
            
        end
    end

    def collision(shape, shape_pos)
        return true if shape_pos - shape.size == 0
        return shape.each_with_index.any? do |line, idx|
            # p("idx shape #{shape} #{idx} #{shape_pos} #{line}")
            line & (@rows[shape_pos + idx] || 0) != 0
        end
    end


        # if bottom_height == 0 || 
        #     p("bottom height is 0! colliding with floor!")
        #     @rows.push(*shape)
        #     return
        # end

        # shape.each_with_index do |idx, line|
        #     p("Shape row index", shape_row_id)
        #     # matching_id = bottom_height + shape.size - idx
        #     # p(matching_id)
        #     if @rows[matching_id] & line
        #         @rows.push(*shape)
        #         return
        #     end
        # end

    # end

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
        @rows = []
        iter.times.each {drop}
    end

    def display
        @rows.reverse_each do |line|
            return "......." if line.nil?

            p(line)
            line.to_s(2)
                .rjust(7, "0")
                .gsub("1", "@")
                .gsub("0", ".")
        end.each do |line|
            print("|#{value}|\n")
        end
    
        print("+-------+\n")
    end
end


grid = Grid.new(shapes, wind.chars)
grid.begin(2)





grid.display
# p(shapes)
# p(value)
