#!/usr/bin/env ruby

require "matrix"

class Grid
    def initialize
        @cells = {}
    end

    def set(vector, value)
        @cells[vector] = value
    end

    def set_if_not_set(vector, value)
        @cells[vector] ||= value
    end

    def get(vector)
        @cells[vector]
    end

    def row_len(y)
        v = @cells.filter do |index, value|
            index[1] == y && value != "B"

            #  && index[0] != "B"

            
            # maybe ch
            # next if index[0] != x 
            # p("hi, #{value} #{index}")
        end


        
        v.size
        # p(v.size)
        # p(v)

        # v.values.join("")

        # p(v.values_at)


        # nil
        # p(v)
        # exit
    end

    def display(sensors)
        vectors = @cells.keys

        minmax_row = vectors.map{|v| v[1]}.minmax
        minmax_row[0] -= 10
        minmax_row[1] += 10
        minmax_col = vectors.map{|v| v[0]}.minmax

        minmax_col[0] -= 10
        minmax_col[1] += 10

        row_legend_len = minmax_row.max.to_s.size + 1


        print("".rjust(minmax_row.max.to_s.size + 1))
        Range.new(*minmax_col).each do |col|    
            next if col >= 10 || col < 0
            print(col)
        end
        print("\n")

        Range.new(*minmax_row).each do |row|
            print("#{row.to_s.rjust(row_legend_len)} ")
            Range.new(*minmax_col).each do |col|    
                vec = Vector[col, row]
                if @cells[vec]
                    print @cells[vec]
                elsif sensors.any?{|sensor| sensor.in_range(vec)}
                    print "#"
                else
                    print(".")
                end
            end
            print("\n")
        end
    end
end


class Sensor
    def initialize(vector, distance)
        @vector = vector
        @distance = distance
    end

    def range(y)
        start_x = nil
        end_x = nil
        Range.new(min_x, max_x).each do |x|
            
            if in_range(Vector[x, y])
                # p("#{Vector[x, y]} is in range")
                if start_x == nil
                    start_x = x
                end
            elsif start_x != nil
                p("#{Range.new(start_x, x - 1)} min #{min_x} max #{max_x}")
                return Range.new(start_x, x - 1)
            end
        end

        if start_x != nil
            p("Problem #{Range.new(start_x, end_x ? end_x : max_x)}")
        end

        # p("Start #{start_x} end #{end_x}")
        start_x.nil? ? nil : Range.new(start_x, end_x ? end_x : max_x)
    end


    def min_x
        @vector[0] - distance
    end

    def max_x
        @vector[0] + distance
    end

    def distance
        @distance
    end

    def in_range(vector)
        # return false if @vector != Vector[8, 7]

        # p("#{vector} #{@vector} #{(@vector - vector)}")
        return (@vector - vector).to_a.map(&:abs).sum <= distance

        if vector == Vector[2, 10]
            # p("Veeeev #{@vector}")
            p(distance)
        end

        sx = @vector[0]
        sy = @vector[1]
        Range.new(1, distance).each do |distance|
            Range.new(0, distance).each do |offset1|
                offset2 = distance - offset1
                [-1, 1].each do |x_multiply|
                    [-1, 1].each do |y_multiply|
                        # p(offset1)
                        if sx + (offset1 * x_multiply) == vector[0] && sy + (offset2 * y_multiply) == vector[1]
                            # p("#{offset1} #{offset2}")
                            return true 
                        end
                        # grid.set_if_not_set(Vector[sx + (offset1 * x_multiply), sy + (offset2 * y_multiply)], "#")
                    end
                end
            end
        end
        false
    end
end

grid = Grid.new
sensors = []

# grid.set(Vector[0, 1], "U")
value = STDIN.read.lines(chomp: true)
    .each do |instruction|
        p(instruction)
        instruction.scan(/x=(-?\d+).* y=(-?\d+).* x=(-?\d+).* y=(-?\d+)/) do |sx, sy, bx, by|
            (sx, sy, bx, by) = [sx, sy, bx, by].map(&:to_i)
            beacon = Vector[bx, by]
            sensor = Vector[sx, sy]
            # p(" Sensor #{sensor} Beacon #{beacon}")
            grid.set(sensor, "S")
            grid.set(beacon, "B")
            # x_distance = [beacon, sensor].map(&:first).max - [beacon, sensor].map(&:first).min
            # y_distance = [beacon, sensor].map{|v| v[1]}.max - [beacon, sensor].map{|v| v[1]}.min
            # distance = x_distance + y_distance
            distance = (sensor - beacon).to_a.map(&:abs).sum
            sensors.push(Sensor.new(sensor, distance))
            # if sensor == Vector[8, 7]
                # Range.new(1, distance).each do |distance|
                #     Range.new(0, distance).each do |offset1|
                #         offset2 = distance - offset1
                #         [-1, 1].each do |x_multiply|
                #             [-1, 1].each do |y_multiply|
                #                 grid.set_if_not_set(Vector[sx + (offset1 * x_multiply), sy + (offset2 * y_multiply)], "#")
                #             end
                #         end
                #     end
                # end
            # end
        end
    end

# grid.display(sensors)


ranges = []
sensors.each do |sensor|
    p("#{sensor}")
    next if (range = sensor.range(2000000)).nil?
    ranges << range


    # if !range.nil?
    #     p("yay", sensor, range)
    # end
end

sorted_ranges = ranges.sort_by(&:min)
# p(sorted_ranges)

pos = sorted_ranges.first.min

size = 0
new_ranges = []
sorted_ranges.each do |range|
    next if range.last < pos
    range = Range.new([pos, range.first].max, range.last)
    new_ranges << range
    size += range.size
    pos = range.last + 1
    p("#{range}, #{range.size}")
end

new_ranges = new_ranges.filter{|range| range.size != 0}

p(new_ranges)

p(size)
# p(sorted_ranges[0].size)


# p(grid.row_len(10))
# p(value)
