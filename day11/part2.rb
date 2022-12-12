#!/usr/bin/env ruby

Monkey = Struct.new(
    :items,
    :operation,
    :test,
    :true,
    :false,
    :inspections
)


def build_lambda(line)
    op = line.match(/= ([^ ]*) (.) ([^ ]*)/).to_a.drop(1)
    if op[0] == "old" && op[2] == "old"
        if op[1] == "*"
            ->(item) { item * item }
        else
            ->(item) { item + item }
        end
    elsif op[0] == "old"
        second = op[2].to_i
        if op[1] == "*"
            ->(item) { item * second }
        else
            ->(item) { item + second }
        end
    end
end


monkeys = STDIN.read.split("\n\n")
    .map do |monkey|
        lines = monkey.lines(chomp: true).drop(1).map{_1.split(":").last.strip}

        
        Monkey.new(
            lines[0].split(",").map{_1.strip.to_i},
            build_lambda(lines[1]),
            lines[2].match(/(\d+)/)[0].to_i,
            lines[3].match(/monkey (\d*)/)[1].to_i,
            lines[4].match(/monkey (\d*)/)[1].to_i,
            0
        )
    end

divisor = monkeys.map(&:test).reduce(1){_1 * _2}

10000.times do |index|
    monkeys.each do |monkey|
        until monkey.items.empty? 
            item = monkey.items.shift
            monkey.inspections += 1
            item = monkey.operation.call(item) % divisor
            monkeys[item % monkey.test == 0 ? monkey.true : monkey.false].items.push(item)
        end
    end
end


monkeys.each_with_index do |monkey, index|
    print("Monkey #{index} #{monkey.inspections}\n")
end

p(monkeys.map(&:inspections).max(2).reduce(1) {_1 * _2})

