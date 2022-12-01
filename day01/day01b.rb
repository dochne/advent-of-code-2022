filename = ARGV[0]
input = File.read(filename).gsub(/\r/, "")

calories_by_elf = input.split("\n\n")
    .map{|items| items.split("\n").map(&:to_i).sum }

p(calories_by_elf.sort!.reverse.take(3).sum)