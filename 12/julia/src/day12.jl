module day12
using LinearAlgebra

export Coordinate,
    North,
    East,
    South,
    West,
    Left,
    Right,
    Forward,
    Instruction,
    Ferry,
    FerryWithWaypoint,
    execute,
    execute_all,
    distance

"""
Integer vector represents ship position and translation movements in a given direction.
"""
const Coordinate = AbstractVector{Int}

function Coordinate(x, y)
    [x, y]
end

North(y) = Coordinate(0, y)
East(x) = Coordinate(x, 0)
South(y) = Coordinate(0, -y)
West(x) = Coordinate(-x, 0)

function distance(c0::Coordinate, c1::Coordinate)
    Δc = c1 - c0
    abs.(Δc) |> sum
end


"""
Wrapped int type that automatically that represent angles in a [0..360) range
"""
struct Angle
    angle::Int
    Angle(a) = new((a < 0 ? a + 360 : a) % 360)
end

angle(a::Angle) = a.angle

Base.:(+)(x::Angle, y::Angle) = Angle(angle(x) + angle(y))
Base.:(==)(x::Angle, y::Int) = angle(x) == y
Base.convert(::Type{Angle}, x::Int) = Angle(x)

Left(a)::Angle = -a
Right(a)::Angle = a


"""
Represents translation without an associated direction
"""
struct Step
    length::Int
end

Base.convert(::Type{Step}, x::Int) = Step(x)
length(s::Step) = s.length

Forward(d)::Step = d

"""
Creates instructions from string literal.
"""
Instruction(instruction) = begin
    action = instruction[1]
    arg = parse(Int, instruction[2:end])

    if action == 'N'
        North(arg)
    elseif action == 'E'
        East(arg)
    elseif action == 'S'
        South(arg)
    elseif action == 'W'
        West(arg)
    elseif action == 'L'
        Left(arg)
    elseif action == 'R'
        Right(arg)
    elseif action == 'F'
        Forward(arg)
    end
end


abstract type AbstractFerry end
position(f::AbstractFerry) = f.position
heading(f::AbstractFerry) = f.heading
distance(f0::AbstractFerry, f1::AbstractFerry) = distance(position(f0), position(f1))
function execute_all(f::AbstractFerry, instructions)
    rv = f
    for i in instructions
        rv = execute(rv, i)
    end
    rv
end


struct Ferry <: AbstractFerry
    position::Coordinate
    heading::Angle
    Ferry() = Ferry(Coordinate(0, 0), Angle(90))
    Ferry(p, h::Angle) =
        angle(h) ∉ [0, 90, 180, 270] ? error("Invalid heading: $(h)") : new(p, h)
    Ferry(x, y, h) = Ferry(Coordinate(x, y), h)
end

function execute(f::Ferry, c::Coordinate)
    Ferry(position(f) + c, heading(f))
end

function execute(f::Ferry, t::Angle)
    Ferry(position(f), heading(f) + t)
end

function execute(f::Ferry, s::Step)
    (x, y) = position(f)
    h = heading(f)
    l = length(s)
    if h == 0
        Ferry(x, y + l, h)
    elseif h == 90
        Ferry(x + l, y, h)
    elseif h == 180
        Ferry(x, y - l, h)
    elseif h == 270
        Ferry(x - l, y, h)
    end
end


struct FerryWithWaypoint <: AbstractFerry
    ferry::Ferry
    waypoint::Coordinate
end

FerryWithWaypoint() = FerryWithWaypoint(Ferry(), Coordinate(10, 1))

position(f::FerryWithWaypoint) = position(ferry(f))
heading(f::FerryWithWaypoint) = heading(ferry(f))
waypoint(f::FerryWithWaypoint) = f.waypoint
ferry(f::FerryWithWaypoint) = f.ferry

function execute(f::FerryWithWaypoint, c::Coordinate)
    FerryWithWaypoint(ferry(f), waypoint(f) + c)
end

function execute(f::FerryWithWaypoint, t::Angle)
    𝑹₉₀ = [
        0 1
        -1 0
    ]
    𝑹ₓ = Dict(Angle(0) => I, Angle(90) => 𝑹₉₀, Angle(180) => -I, Angle(270) => -𝑹₉₀)
    FerryWithWaypoint(ferry(f), 𝑹ₓ[t] * waypoint(f))
end

function execute(f::FerryWithWaypoint, s::Step)
    FerryWithWaypoint(Ferry(position(f) + length(s) * waypoint(f), heading(f)), waypoint(f))
end


function readfile()
    lines = open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
    Instruction.(lines)
end

function run()
    instructions = readfile()

    f0 = Ferry()
    ferry = execute_all(f0, instructions)
    result = distance(ferry, f0)
    println("The Manhattan distance between that location and the ship's starting positiontion is $(result)")

    f0 = FerryWithWaypoint()
    ferry = execute_all(f0, instructions)
    result = distance(ferry, f0)
    println("The Manhattan distance between that location and the ship's starting positiontion using waypoints is $(result)")
end
end
