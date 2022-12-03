#!/usr/bin/env ruby

value = STDIN.read.lines(chomp: true)
    .map{|line| line.split("")}
    .map{|items| next items.slice!(0, (items.length / 2).ceil), items}
    .map{|slot1, slot2| slot1 & slot2 }
    .flatten
    .map{|item| item.ord > 96 ? item.ord % 96 : (item.ord % 64) + 26}
    .sum

p(value)
