#!/usr/bin/env ruby

Operation = Struct.new(
    :first,
    :operator,
    :second
)

Monkey = Struct.new(
    :items,
    :operation,
    :test,
    :true,
    :false,
    :inspections
)

monkeys = STDIN.read.split("\n\n")
    .map do |monkey|
        lines = monkey.lines(chomp: true).drop(1).map{_1.split(":").last.strip}
        Monkey.new(
            lines[0].split(",").map{_1.strip.to_i},
            Operation.new(*lines[1].match(/= ([^ ]*) (.) ([^ ]*)/).to_a.drop(1)),
            lines[2],
            lines[3].match(/monkey (\d*)/)[1].to_i,
            lines[4].match(/monkey (\d*)/)[1].to_i,
            0
        )
    end

20.times do
    monkeys.each do |monkey|
        until monkey.items.empty? 
            item = monkey.items.shift

            monkey.inspections = monkey.inspections + 1
            first = monkey.operation.first
            second = monkey.operation.second
            first = item if first == "old"
            second = item if second == "old"

            if monkey.operation.operator == "*"
                item = first.to_i * second.to_i
            elsif monkey.operation.operator == "+"
                item = first.to_i + second.to_i
            else
                raise "Oh no"
            end

            item = item / 3
            divisor = monkey.test.match(/(\d+)/)[0].to_i
            monkeys[item % divisor == 0 ? monkey.true : monkey.false].items.push(item)
        end
    end
end


monkeys.each_with_index do |monkey, index|
    print("Monkey #{index} #{monkey.items}\n")
end

p(monkeys.map(&:inspections).max(2).reduce(1) {_1 * _2})

