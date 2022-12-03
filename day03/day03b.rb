#!/usr/bin/env ruby

class Array
    def in_groups_of(size)
        buffer = []
        self.each_slice(size){|slice| buffer << slice}
        buffer
    end
end

value = STDIN.read.lines(chomp: true)
    .map{|line| line.split("")}
    .in_groups_of(3)
    .map{|elf1, elf2, elf3| elf1 & elf2 & elf3 }
    .flatten
    .map{|item| item.ord > 96 ? item.ord % 96 : (item.ord % 64) + 26}
    .sum

p(value)
