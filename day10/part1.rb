#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)

record = [1]

input.each do |(command, output)|
    case command.split(" ")
        in ['addx', number]
            record << record.last
            record << record.last + number.to_i
        in ['noop']
            record << record.last
    end
end

value = [20, 60, 100, 140, 180, 220].map{|i| record[i - 1] * i}.sum

p(value)