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

instructions.scan(/move (\d+) from (\d+) to (\d+)/)
    .map{|v| v.map(&:to_i)}
    .each do |total, src, dest|
        buffer = []
        total.times.each {buffer.unshift(cargo[src].pop)}
        cargo[dest].push(*buffer)
    end

value = Range.new(1, cargo.size).map{|col| cargo[col].pop}.join("")

p(value)
