#!/usr/bin/env julia
module day24

export E, NE, SE, W, NW, SW, parse_path, parse_input, tiles, flip, count_blacks

E = (0, 2)
NE = (1, 1)
SE = (-1, 1)
W = (0, -2)
NW = (1, -1)
SW = (-1, -1)
DIRECTIONS = (W, NW, NE, E, SE, SW)

function parse_path(str)
    path = []
    i = 1
    while i <= length(str)
        if str[i] == 'e'
            push!(path, E)
            i += 1
        elseif str[i] == 'w'
            push!(path, W)
            i += 1
        elseif str[i:i+1] == "ne"
            push!(path, NE)
            i += 2
        elseif str[i:i+1] == "nw"
            push!(path, NW)
            i += 2
        elseif str[i:i+1] == "se"
            push!(path, SE)
            i += 2
        elseif str[i:i+1] == "sw"
            push!(path, SW)
            i += 2
        end
    end
    path
end

function parse_input(input)
    lines = split(strip(input), "\n")
    parse_path.(lines)
end

function tiles(paths)
    ep = Dict()
    for path in paths
        e = reduce((a, b) -> a .+ b, path)
        count = get(ep, e, 0)
        count += 1
        ep[e] = count
    end
    ep
end

function count_blacks(floor)
    count(kv -> kv.second % 2 == 1, floor)
end

function neighbours(tile)
    [tile .+ d for d in DIRECTIONS]
end

function neighbourblacks(floor, tile)
    blacks = 0
    for d in neighbours(tile)
        blacks += (get(floor, d, 0) % 2)
    end
    blacks
end

function discoverneighbours!(floor)
    for t in keys(floor)
        for n in neighbours(t)
            f = get(floor, n, 0)
            if f % 2 == 1 || neighbourblacks(floor, n) == 2
                floor[n] = f
            end
        end
    end
end

function flip(floor)
    next = Dict()
    discoverneighbours!(floor)
    for (tile, flips) in floor
        blacks = neighbourblacks(floor, tile)
        if (flips % 2) == 1 && (blacks == 0 || blacks > 2)
            next[tile] = flips + 1
        elseif (flips % 2) == 0 && blacks == 2
            next[tile] = flips + 1
        else
            next[tile] = flips
        end
    end
    next
end

function flip(floor, count)
    for i = 1:count
        floor = flip(floor)
    end
    floor
end

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end

function run()
    input = readfile()
    paths = parse_input(input)
    ts = tiles(paths)
    blacks = count_blacks(ts)
    println("There are $blacks tiles left black side up.")
    blacks = count_blacks(flip(ts, 100))
    println("There are $blacks tiles left black side up on the 100th day.")
end
if abspath(PROGRAM_FILE) == @__FILE__
    using Pkg
    Pkg.activate(dirname(@__DIR__))
    run()
end
end
