#!/usr/bin/env ruby

cargo, instructions = STDIN.read.split("\n\n")

cargo = cargo.lines(chomp: true)
    .map{|line| line.split("")}
    .reduce({}) do |acc, chars|
        chars.each_with_index do |char, index|
            next unless char.match(/[A-Z]/)
            col = ((index + 3)/ 4)
            acc[col] = [] if acc[col].nil?
            acc[col].unshift(char)
        end
        acc
    end

instructions.lines(chomp:true).each do |instruction|
    instruction.scan(/move (\d+) from (\d+) to (\d+)/) do |total, src, dest|
        total.to_i.times.each {cargo[dest.to_i].push(cargo[src.to_i].pop)}
    end
end


value = Range.new(1, cargo.size).map do |col|
    cargo[col].pop
end.join("")


p(value)
