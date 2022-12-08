#!/usr/bin/env ruby

rows = STDIN.read.lines(chomp: true)
    .map{|row| row.chars.map(&:to_i)}

cols = rows.reduce([]) do |acc, row|
    row.each_with_index do |char, index|
        acc[index] = acc[index] || []
        acc[index].push(char)
    end
    acc
end

height = rows.size
width = cols.size

total = 0

rows.each_with_index do |row, row_id|
    next if row_id == 0 || row_id == height - 1

    row.each_with_index do |value, col_id|
        next if col_id == 0 || col_id == width - 1
        col = cols[col_id]

        next if row.slice(0, col_id).max < value
        next if row.slice(col_id + 1, width).max < value
        next if col.slice(0, row_id).max < value
        next if col.slice(row_id + 1, height).max < value
        total += 1
    end
end

p((width * height) - total)
