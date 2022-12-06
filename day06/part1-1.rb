#!/usr/bin/env ruby

require "set"

len = 4

value = STDIN.read.lines(chomp: true)
    .first
    .chars
    .each_cons(len)
    .map(&:to_set)
    .each.with_index
    .reduce{ | _, (value, index) | break index + len if value.length == len }

p(value)
