#!/usr/bin/env ruby

Folder = Struct.new(:filename, :parent, :children, :files)
File_ = Struct.new(:filename, :size)

root = Folder.new("/", nil, {}, {})
pwd = root

input = STDIN.read.split("$")
    .map(&:strip)
    .filter{|v| v.length > 0}
    .map{|v| v.split("\n", 2)}

input.each do |(command, output)|
    case command.split(" ")
        in ['cd', dir]
            if dir == "/"
                pwd = root 
            elsif dir == ".."
                pwd = pwd.parent
            else
                pwd.children[dir] = pwd.children[dir] || Folder.new(dir, pwd, {}, {})
                pwd = pwd.children[dir]
            end
        in ['ls']
            output.lines(chomp: true).each do |line|
                case line.split(" ")
                    in ['dir', dir]
                        pwd.children[dir] = pwd.children[dir] || Folder.new(dir, pwd, {}, {})
                    in [filesize, filename]
                        pwd.files[filename] = File_.new(filename, filesize.to_i)
                end
            end
    end

end

def recurse(dir)
    folders = []
    size = 0
    dir.children.each do |key, folder|
        rfolders, rsize = recurse(folder)
        folders.push(*rfolders)
        size += rsize
    end
    file_size = dir.files.map{|_, v| v.size}.sum
    size += file_size
    folders << size
    return folders, size
end


folders, size = recurse(root)
remaining = 70000000 - size
required = 30000000 - remaining
large_enough = folders.filter{|v| v > required}

p(large_enough.min)
