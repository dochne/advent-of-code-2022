#!/usr/bin/env ruby

require "json"


def log(*args)
    p(args)
end

def compare(left, right)
    return false if right.nil?

    if left.is_a?(Integer) && right.is_a?(Integer)
        if left < right
            return true
        elsif left > right
            return false
        end
        return nil
    end

    if left.is_a?(Integer) ^ right.is_a?(Integer)
        left = Array(left)
        right = Array(right)
    end

    left.each_with_index do | _, index |
        check = compare(left[index], right[index])
        return check unless check.nil?
    end

    return true if right.size > left.size
    nil
end

value = STDIN.read.split("\n\n")
    .each_with_index.reduce(0) do |acc, (signal, index)|
        left, right = signal.split("\n").map{JSON.parse(_1)}
        value = compare(left, right)
        value = true if value.nil?

        if value
            acc += index + 1
        else
            acc
        end
    end

p(value)
