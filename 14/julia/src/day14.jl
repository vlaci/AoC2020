module day14

export Computer, ComputerV2, Program, execute, memory

struct Mask
    pattern::String
end

function apply(m::Mask, arg)
    (arg | m.or) & m.and
end


struct Load
    addr::UInt64
    value::UInt64
    function Load(addr, value)
        new(parse(UInt64, addr), parse(UInt64, value))
    end
end


const Instruction = Union{Mask,Load}

function Base.parse(::Type{Instruction}, ins)
    parsed = match(r"(?P<ins>mask|mem)(\[(?P<addr>\d+)\])? = (?P<value>[01X]{36}|\d+)", ins)
    if parsed[:ins] == "mask"
        Mask(parsed[:value])
    elseif parsed[:ins] == "mem"
        Load(parsed[:addr], parsed[:value])
    end
end


const Program = Vector{Instruction}

function Base.parse(::Type{Program}, program)
    [parse(Instruction, i) for i in program]
end

abstract type AbstractComputer end

function execute(c::AbstractComputer, program)
    for ins in program
        execute(c, ins)
    end
end

function memory(c::AbstractComputer)
    c.memory
end


mutable struct Computer <: AbstractComputer
    or_pat::UInt64
    and_pat::UInt64
    memory::Dict{UInt64,UInt64}
    function Computer()
        new(0, 0, Dict())
    end
end

function execute(c::Computer, ins::Mask)
    c.or_pat = parse(UInt64, replace(ins.pattern, 'X' => '0'), base = 2)
    c.and_pat = parse(UInt64, replace(ins.pattern, 'X' => '1'), base = 2)
end

function execute(c::Computer, ins::Load)
    c.memory[ins.addr+1] = (ins.value | c.or_pat) & c.and_pat
end

mutable struct ComputerV2 <: AbstractComputer
    or_pat::UInt64
    float_pats::Vector{UInt64}
    memory::Dict{UInt64,UInt64}
    function ComputerV2()
        new(0, [], Dict())
    end
end

function execute(c::ComputerV2, ins::Mask)
    c.or_pat = parse(UInt64, replace(ins.pattern, 'X' => '1'), base = 2)
    pattern = replace(ins.pattern, '0' => '1') |> collect
    numfloating = 2^count(b -> b == 'X', pattern)
    c.float_pats = []
    for i = 0:numfloating-1
        float_mask = digits(i, base = 2, pad = 36)
        j = 1
        m = copy(pattern)
        for (i, c) in enumerate(pattern)
            if c == 'X'
                m[i] = string(float_mask[j])[1]
                j += 1
            end
        end
        m = reduce(*, m)
        push!(c.float_pats, parse(UInt64, m, base = 2))
    end
end

function execute(c::ComputerV2, ins::Load)
    for mask in c.float_pats
        c.memory[(ins.addr|c.or_pat)&mask] = ins.value
    end
end

function readfile()
    lines = open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
    parse.(Instruction, lines)
end

function run()
    program = readfile()
    c = Computer()
    execute(c, program)
    result = sum(c |> memory |> values)
    println("The sum of all values left in memory after it completes is $(result)")
    c = ComputerV2()
    execute(c, program)
    result = sum(c |> memory |> values)
    println("The sum of all values left in memory after it completes is $(result)")
end
end
