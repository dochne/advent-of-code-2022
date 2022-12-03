#!/usr/bin/env ruby

calories_by_elf = STDIN.read.split("\n\n")
    .map{|items| items.split("\n").map(&:to_i).sum }

p(calories_by_elf.sort!.last(3).sum)