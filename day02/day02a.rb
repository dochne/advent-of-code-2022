#!/usr/bin/env ruby


# In the first round, your opponent will choose Rock (A), and you need the round to end in a draw (Y), so you also choose Rock. This gives you a score of 1 + 3 = 4.
# In the second round, your opponent will choose Paper (B), and you choose Rock so you lose (X) with a score of 1 + 0 = 1.
# In the third round, you will defeat your opponent's Scissors with Rock for a score of 1 + 6 = 7.

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