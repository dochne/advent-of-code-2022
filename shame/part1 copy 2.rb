#!/usr/bin/env ruby

require "matrix" 

Valve = Struct.new(:id, :rate, :tunnels)
Event = Struct.new(:pos, :event)

valves = STDIN.read.lines(chomp: true)
    .map do |instruction|
        instruction.scan(/^Valve ([^ ]+).*=(\d+).*valves? (.*)/) do | id, rate, valves |
            break Valve.new(id, rate.to_i, valves.split(",").map(&:strip))
        end
    end
    .compact
    .reduce({}) do |acc, valve|
        acc[valve.id] = valve
        acc
    end

class State
    def initialize(valves, time, pos)
        @valves = valves
        @time = time
        @pos = pos
        @stack = []
        @released = 0
        @total = 0
        @iterations = 0
        @paths = paths
    end

    def valve
        @valves[@pos]
    end

    def paths
        response = {}
        @valves.each do |from, _|
            response[from] = {}
            @valves.keys.each do |to, _|
                response[from][to] = path(from, to)
                # response[Vector[from, to]] = path(from, to)
            end
        end
        response
    end

    def path(start, finish)
        frontier = [start]
        visited = {start => nil}

        while frontier.size > 0
            parent = frontier.shift
            @valves[parent].tunnels.each do |index|
                unless visited.has_key?(index)
                    frontier.push(index)
                    visited[index] = parent
                    if index == finish
                        response = []
                        while visited[index] != nil do
                            response << index
                            index = visited[index]
                        end
                        return response.reverse
                    end
                end
            end
        end

    end


    def tunnels
        endpoints = @valves.filter{|v| @valves[v].rate > 0}

        
        @paths[@pos].values.compact.map(&:first).uniq

        # p()

        # exit
        # response = []
        # heh = endpoints.keys.each do |v|
        #     @paths[@pos][v].first
        # end

        # p(@pos)


        # p(endpoints.size)
        # p(@paths[@pos])

        # exit


        # # p("#{endpoints}")
        # valve.tunnels
    end

    def total
        @total + (@released * @time)
    end

    def global
        return [@global1, @global2]
    end

    def tick(&block)
        return total if @time == 1
        # @global1 += 1
        @time -= 1
        @total += @released
        value = yield
        # @global2 += 1
        @total -= @released
        @time += 1
        value
    end

    def open(&block)
        result = nil
        current_flow = valve.rate
        if current_flow > 0
            # p("Opening valve at #{@pos}")
            tick do
                @released += current_flow
                valve.rate = 0
                @stack << "#{@pos}-o"
                result = yield
                @stack.pop
                valve.rate = current_flow
                @released -= current_flow
            end
        end
        result
    end

    def walk(pos, &block)
        # p("Walking to #{pos} #{@time}")
        tick do
            last_here = @stack.rindex{|path| path == "#{pos}-w"}

            if last_here
                # v = @stack.slice(last_here, @stack.size).none?{|v| v.chars.last == "o"}
                next total if @stack.slice(last_here, @stack.size).none?{|v| v.chars.last == "o"}
                #     p(@stack)
                #     p("Skipping to the next one #{pos}-w")
                #     return total
                # end
                # p("#{@stack.slice(last_here, @stack.size)}")
                # p("slice #{v}")
                # return total if @stack.slice(last_here, @stack.size).none?{|v| v.chars.last == "o"}
            end

            current_pos = @pos
            @stack << "#{pos}-w"
            @pos = pos
            value = enter
            @stack.pop
            @pos = current_pos
            value
        end
    end

    def enter
        # print("#{@stack} Released #{@released} Time #{@time} Total #{@total}\n")
        @iterations += 1
        if (@iterations % 10000 == 0)
            print("Iteration #{@iterations} #{@stack}\n")
            # print("Tunnels #{@valves.filter{|v, _| @valves[v].rate > 0}.sum}\n")
        end

        [
            open{tunnels.map{|tunnel| walk(tunnel)}.max},
            tunnels.map{|tunnel| walk(tunnel)}.max,
        ].compact.max
    end
end


state = State.new(valves, 30, "AA")
p(state.enter)

# p(state.global)