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
beacons = []

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
            beacons << beacon
        end
    end

ranges = sensors
    .map{|sensor| sensor.range(y)}
    .compact
    .sort_by(&:min)

pos = ranges.first.min
size = 0
new_ranges = []
ranges.each do |range|
    next if range.last < pos
    range = Range.new([pos, range.first].max, range.last)
    new_ranges << range
    size += range.size
    pos = range.last + 1
    p("#{range}, #{range.size}")
end

new_ranges = new_ranges.filter{|range| range.size != 0}

beacons_on_line = beacons.filter{|b| b[1] == y}.uniq.size

p(new_ranges)

p(size - beacons_on_line)
