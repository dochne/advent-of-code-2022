#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)

reg = 1
screen = []
draw = -> {[reg - 1, reg, reg + 1].include?(screen.size % 40) ? "#" : "."}

input.each do |(command, output)|
    case command.split(" ")
        in ['addx', number]
            screen << draw.call
            screen << draw.call
            reg += number.to_i
            
        in ['noop']
            screen << draw.call
    end
end

screen.each_slice(40) do |slice|
    print("#{slice.join("")}\n")
end