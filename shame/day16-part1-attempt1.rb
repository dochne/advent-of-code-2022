#!/usr/bin/env ruby


# The big kicker with this problem will be if we have to go through the *same* room multiple times
# actually doesn't matter - 60 minute limit

Valve = Struct.new(:id, :rate, :tunnels)

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

# p(valves)
# exit    

def recurse(valves, pos, time, path = [], released_flow = 0, total_pressure = 0)
    # sleep(0.5)
    # p("Entering #{valves[pos]}")
    # p("Remaining pressure #{valves.map{_2.rate}.sum}")
    # p("Unopened #{valves.filter{_2.rate > 0}.map{_2.id}.join(",")}")
    valve = valves[pos]
    p(path.map{|v| "#{v[0]}:#{v[1]}:#{v[2]}"})
    
    return (released_flow * time) + total_pressure if time <= 1 || valves.map{_2.rate}.sum == 0
    

    last_here = path.rindex{|item| item[0] == pos}

    if last_here
        history = path.slice(last_here, path.size)
        # p("H #{history}")
        # p(history.map{|v| v[1]})
        return time * released_flow if history.map{|v| v[1]}.sum == 0 || history.map{|v| v[2]}.sum == 0

        # p(last_here)
        # exit
    end
    # p("#{path.size} #{time}")
    # p(path.size)

    
    options = []
    # we can choose to walk without opening anything

    current_rate = valve.rate
    
    path << [pos, current_rate, 0]

    # path << [pos, valve.rate]
    options << valve.tunnels.map do |tunnel|
        recurse(valves, tunnel, time - 1, path.dup, released_flow, total_pressure + (1 * released_flow))
    end

    path.pop
    # path.pop

    # release the valve

    
    if valve.rate > 0
        path << [pos, current_rate, 1]
        # p("Opening #{pos} #{valve.rate}")
        time -= 1
        total_pressure += (1 * released_flow)
        released_flow += current_rate
        valves[pos].rate = 0
        # p("#{valves[pos].rate}")
    else
        # p("Valve #{pos} Open/Broken")
    end
    
    # walk to a new place, with one addition less minute of time!

    
    options << valve.tunnels.map do |tunnel|
        recurse(valves, tunnel, time - 1, path.dup, released_flow, total_pressure + (1 * released_flow))
    end
    path.pop

    valves[pos].rate = current_rate
    
    # if path.size > 40
    #     p(path)
    #     exit
    # end

    options.flatten.max
end

p(recurse(valves, "AA", 30))


# class Volcano
#     def initialize(valves)
#         @valves = valves
#         # @released = 0
#         # @total = 0
#     end

#     def valve(pos)
#         @valves[pos]
#     end

#     def recurse(pos, time, released, total, path)
#         return total if time <= 1

#         valve = valve(pos)

#         options = []
#         # we can choose to walk without opening anything
#         # options << valve.tunnels.map do |tunnel|
#         #     recurse(valves, tunnel, time - 1, released_flow, total_pressure += (1 * released_flow))
#         # end

#         # release the valve
#         current = valve.rate
#         released += current_rate
#         valves[pos].rate = 0
        
#         # walk to a new place, with one addition less minute of time!
#         options << valve.tunnels.map do |tunnel|
#             recurse(valves, tunnel, time - 2, released_flow, total_pressure += (1 * released_flow))
#         end

#         valves[pos].rate = current_rate
        
#         options.flatten.max
#     end
# end

# volcano = Volcano.new(valves)

# volcano.recurse("AA", 60, [])
