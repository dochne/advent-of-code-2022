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

    p("File size is #{file_size}")
    size += file_size

    folders << size

    p("Folder #{dir.filename} is size #{file_size}")

    p("Folders #{folders}")
    # p("Folders")
    # p(folders)
    return folders, size
end


v = recurse(root)
p(v.flatten)
p(v.flatten.filter{|v| v <= 100000}.sum)