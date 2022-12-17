#!/usr/bin/env ruby

require "matrix"

class Sensor
    def initialize(vector, distance)
        @vector = vector
        @distance = distance
    end

    def range(y)
        distance = @distance - (@vector - Vector[0, y])[1].abs
        return nil if distance < 0
        return Range.new(@vector[0] - distance, @vector[0] + distance)
    end
end

sensors = []

y = 2000000
value = STDIN.read.lines(chomp: true)
    .each do |instruction|
        p(instruction)
        instruction.scan(/x=(-?\d+).* y=(-?\d+).* x=(-?\d+).* y=(-?\d+)/) do |sx, sy, bx, by|
            (sx, sy, bx, by) = [sx, sy, bx, by].map(&:to_i)
            sensor = Vector[sx, sy]
            beacon = Vector[bx, by]

            distance = (sensor - beacon).to_a.map(&:abs).sum

            sensors << Sensor.new(sensor, distance)
        end
    end


4000000.times do |y|
    if (y % 10000) == 0
        p(y)
    end

    ranges = sensors
        .map{|sensor| sensor.range(y)}
        .compact
        .sort_by(&:min)

    pos = ranges.first.min
    ranges.each do |range|
        next if range.last < pos
        if range.first > pos
            p("#{pos} #{y}")
            p("#{pos * 4000000 + y}")
            exit
        end
        pos = range.last + 1
    end
end