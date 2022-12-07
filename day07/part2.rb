#!/usr/bin/env ruby

# folder1 = Proc.new do |new_class|
#     def output
#         "#{self.filename} (file, size=#{self.size})"
#         # "Hello #{name} at #{address}"
#     end
# end

  
Folder = Struct.new(:filename, :parent, :children, :files)
File_ = Struct.new(:filename, :size)

root = Folder.new("/", nil, {}, {})
pwd = root

input = STDIN.read.split("$")
    .map(&:strip)
    .filter{|v| v.length > 0}
    .map{|v| v.split("\n", 2)}

# p(input)

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
    else
        p("Command")
        p(command)
    end

end

# return the size
def recurse(dir)
    folders = []
    size = 0

    p("Going into folder #{dir.filename}")
    p(dir.files)
    dir.children.each do |key, folder|
        rfolders, rsize = recurse(folder)
        folders.push(*rfolders)
        size += rsize
    end

    # p("Size", size)

    # 94853

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


folders, size = recurse(root)
remaining = 70000000 - size
required = 30000000 - remaining
p(required)


p(remaining)
p("#{folders}")
large_enough = folders.filter{|v| v > required}

p(large_enough.min)

# p(used)
# p(size)
# p(v.flatten)
# p(v.flatten.filter{|v| v <= 100000}.sum)
# def recurse(folder, indent = 0)
#     puts("- #{folder.filename}".rjust(indent * 2, " "))
#     folder.children
#         .filter{|_, v| v.is_a?(Folder)}
#         .each do |_, file|
#             recurse(file, indent + 2)
#         end
    
#     folder.children
#         .filter{|v| !v.is_a?(Folder)}
#         .each do |_, file|
#             puts("- #{file.filename}".rjust((indent + 2) * 2, " "))
#         end

#         # .each do |file|
#         #     p(file.filename.rjust(indent, " "))
#         # end
# end
# p(root)

# recurse(root)

