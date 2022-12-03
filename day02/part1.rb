#!/usr/bin/env ruby

value = STDIN.read.lines(chomp: true)
    .reduce(0) do |acc, match|
        played, response = match.split(" ").map{|char| char.ord % 87 % 64}

        acc + response + if played == response
            3
        elsif response == played + 1 || response == 1 && played == 3
            6
        else
            0
        end
    end
