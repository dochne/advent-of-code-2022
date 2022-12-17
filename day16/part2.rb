#!/usr/bin/env ruby

require "matrix" 

# require 'ruby-prof'
# RubyProf.start

Valve = Struct.new(:id, :rate, :tunnels, :enroute)
Event = Struct.new(:pos, :event)

valves = STDIN.read.lines(chomp: true)
    .map do |instruction|
        instruction.scan(/^Valve ([^ ]+).*=(\d+).*valves? (.*)/) do | id, rate, valves |
            break Valve.new(id, rate.to_i, valves.split(",").map(&:strip), false)
        end
    end
    .compact
    .reduce({}) do |acc, valve|
        acc[valve.id] = valve
        acc
    end


Helper = Struct.new(:label, :position, :sleeping, :total)

class State
    def initialize(valves, time, helpers)
        @valves = valves
        @time = time
        @helpers = helpers
        @stack = []
        @paths = paths
        # @total = 0
    end

    def active
        @valves.filter{|v| @valves[v].rate > 0}
    end

    def route(from, to)
        @paths[from][to]
    end


    def move(helper, to)
        route = route(helper.position, to_pos)
        dist = route.size

        return @total if @time - dist <= 1
        
        from_pos = @current_pos
        from_rate = @valves[from_pos].rate

        @current_pos = to_pos

        to_rate = @valves[to_pos].rate
        @time -= (dist + 1)
        @valves[@current_pos].rate = 0
        @total += @time * to_rate
        @stack.push(route)

        value = enter

        @total -= @time * to_rate
        @valves[@current_pos].rate = to_rate
        @time += (dist + 1)
        @current_pos = from_pos
        @stack.pop

        # p("Returning #{value}")
        value
    end

    def score(from, to)
        route = route(from, to)
        (@time -(route.size + 1)) * @valves[to].rate
    end

    def tick(&block)
        min = @helpers.map(&:sleeping).min
        
        @helpers = @helpers.map{|helper| helper.sleeping -= min}
        @time -= min
        value = yield @helpers.find(|h| h.sleeping == 0)
        @time += min
        @helpers = @helpers.map{|helper| helper.sleeping += min}
        value
    end

    def run
        # min = @helpers.map(&:sleeping).min

        # @helpers = @helpers.map(|v| v.sleeping - time)
        # time -= min

        tick do |helper|
            
            currently_active.map do |id, _|
                move(helper, id)
            end
        end


        # move(helper)
        # currently_active = active
        #     currently_active.map do |id, _|
        #         move(helper, id)
        #     end
        # end
    end

    def wait_on_helper
        

    end



    # def tick
    #     currently_active = active

    #     helpers.each do |helper|
    #         next if helper.sleeping != 0
            
    #         currently_active.map do |id, valve|
    #             score = score(@current_pos, id)            
    #             value = move(id)
    #             p("Move returned #{value} #{@stack}")
    #             value
    #         end.max

            

    #     end

    #     currently_active = active
    #     return @total if currently_active.size == 0

    #     currently_active.map do |id, valve|
    #         score = score(@current_pos, id)            
    #         value = move(id)
    #         p("Move returned #{value} #{@stack}")
    #         value
    #     end.max
    # end

    def paths
        response = {}
        @valves.each do |from, _|
            response[from] = {}
            @valves.keys.each do |to, _|
                response[from][to] = path(from, to)
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

end

# Helper = Struct.new(:label, :position, :sleeping_until)


state = State.new(valves, 30, [
    Helper.new("Human", "AA", 0),
    Helper.new("Elephant", "AA", 0),
])
p(state.enter)

# p(state.global)

# result = RubyProf.stop
# printer = RubyProf::FlatPrinter.new(result)
# printer.print(STDOUT)