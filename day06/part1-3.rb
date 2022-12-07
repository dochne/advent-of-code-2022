#!/usr/bin/env ruby

require "set"

len = 4

value = STDIN.read.lines(chomp: true).first.chars.each_cons(len).find_index{|value| value.uniq.length == len }

p(value + len)
