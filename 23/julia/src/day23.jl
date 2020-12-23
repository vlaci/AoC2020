#!/usr/bin/env julia
module day23

export parsecups, label, play, tomillion, from1

mutable struct CupCircle
    successors::Vector{Int64}
    current::Int64
    function CupCircle(cups::Vector)
        successors = zeros(length(cups))
        for i = 1:length(cups)-1
            # current index points to next index
            successors[cups[i]] = cups[i+1]
        end
        # last index points to first index, thus completing the loop
        successors[cups[end]] = cups[1]
        # start with the first cup in the input
        current = cups[1]
        new(successors, current)
    end
end

function getnext(c::CupCircle, cup)
    c.successors[cup]
end

function setnext(c::CupCircle, cup, next)
    c.successors[cup] = next
end

function getcurrent(c::CupCircle)
    c.current
end

function setcurrent(c::CupCircle, cup::Int64)
    c.successors[c.current] = cup
    c.current = cup
end

function Base.length(c::CupCircle)
    length(c.successors)
end

function move!(cups)
    curr = getcurrent(cups)
    pick = zeros(Int64, 3)
    pick[1] = getnext(cups, curr)
    pick[2] = getnext(cups, pick[1])
    pick[3] = getnext(cups, pick[2])
    next = getnext(cups, pick[3])

    dest = getdest(cups, curr, pick)

    setnext(cups, pick[end], getnext(cups, dest))
    setnext(cups, dest, pick[1])

    setcurrent(cups, next)
end

@inline function getdest(cups, current, pick)
    dest = current - 1
    while dest in pick
        dest -= 1
    end
    if dest < 1
        dest = length(cups)
        while dest in pick
            dest -= 1
        end
    end
    dest
end

function play(cups; moves = 100)
    cups = CupCircle(cups)
    for i = 1:moves
        move!(cups)
    end
    cups
end

function label(cups)
    string.(from1(cups)) |> join
end

function from1(c::CupCircle; count = nothing)
    count = isnothing(count) ? length(c) - 1 : count
    rv = zeros(Int, count)
    next = c.successors[1]
    i = 1
    while i <= count
        rv[i] = next
        next = c.successors[next]
        i += 1
    end
    rv
end

function tomillion(cups)
    cₘₐₓ = maximum(cups)
    [cups; cₘₐₓ+1:1000000]
end

parsecups(input) = parse.(Int, input |> collect)

function run()
    input = "853192647"
    cups = parsecups(input)
    result = play(cups) |> label
    println("The labels of the cups is $result")

    @time cups = play(cups |> tomillion, moves = 10000000)
    result = from1(cups, count = 2)
    println("The product of the cups immediately clockwise to 1 is $(result[1]*result[2])")
end

if abspath(PROGRAM_FILE) == @__FILE__
    using Pkg
    Pkg.activate(dirname(@__DIR__))
    run()
end
end
