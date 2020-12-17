module day17

export parse_init, boot

const State = Set{Tuple{Vararg{Int}}}

function parse_init(init; dimensions)
    state = State()
    for (i, l) in split(init |> strip, "\n") |> enumerate
        for (j, c) in l |> enumerate
            if c == '#'
                push!(state, tuple([[i - 1, j - 1]; zeros(dimensions - 2)]...,))
            end
        end
    end
    state
end

function neighbours(coord)
    [n for n in Iterators.product((map(i -> i-1:i+1, coord))...) if n != coord]
end

function all_neighbours(state)
    neigh = Set()
    for c in state
        union!(neigh, neighbours(c))
    end
    neigh
end

function evolve(state)
    coords = all_neighbours(state)
    s₁ = State()
    for c in coords
        active = c in state
        neigh = length(state ∩ neighbours(c))
        if active && neigh in (2, 3)
            push!(s₁, c)
        elseif !active && neigh == 3
            push!(s₁, c)
        end
    end
    s₁
end

function boot(state; count = 6)
    for i = 1:count
        state = evolve(state)
    end
    state
end

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end

function run()
    state = parse_init(readfile(), dimensions = 3)
    @time result = boot(state)
    println("$(length(result)) cubes are left in the active state after the sixth cycle")

    state = parse_init(readfile(), dimensions = 4)
    @time result = boot(state)
    println("$(length(result)) cubes are left in the active state after the sixth cycle")
end
end
