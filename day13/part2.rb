#!/usr/bin/env ruby

require "json"

def compare(left, right)
    if left.is_a?(Integer) && right.is_a?(Integer)
        return left <=> right
    end

    if left.is_a?(Integer) ^ right.is_a?(Integer)
        left = Array(left)
        right = Array(right)
    end

    left.each_with_index do | _, index |
        return 1 if right[index].nil?
        check = compare(left[index], right[index])
        return check unless check == 0
    end

    return -1 if right.size > left.size
    0
end

value = STDIN.read.split("\n")
    .push("[[2]]", "[[6]]")
    .filter{|v| v.size > 0}
    .map{JSON.parse(_1)}
    .sort {|a, b| compare(a, b)}

key = (value.index([[2]]) + 1) * (value.index([[6]]) + 1)
p(key)
