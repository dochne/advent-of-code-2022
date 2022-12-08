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

score = 0

rows.each_with_index do |row, row_id|
    next if row_id == 0 || row_id == height - 1

    row.each_with_index do |value, col_id|
        next if col_id == 0 || col_id == width - 1
        col = cols[col_id]

        up = col.slice(0, row_id)
        down = col.slice(row_id + 1, height)
        left = row.slice(0, col_id)
        right = row.slice(col_id + 1, width)
        
        up_score = 1 + (up.reverse.find_index { |cell| cell >= value } || up.size - 1)
        down_score = 1 + (down.find_index { |cell| cell >= value } || down.size - 1)

        left_score = 1 + (left.reverse.find_index { |cell| cell >= value } || left.size - 1)
        right_score = 1 + (right.find_index { |cell| cell >= value } || right.size - 1)

        score = [score, up_score * down_score * left_score * right_score].max
    end
end

p(score)
