module day13

export find_bus, find_bus_departure_with_matching_offsets

function next_deprarture(bus, timestamp)
    bus - timestamp % bus
end

function find_bus(earliest, buses)
    [(departsin = next_deprarture(bus, earliest), number = bus) for bus in buses] |> minimum
end

"""
Chineese remainder theorem:

mᵢ: m₁, …, mₖ ∈ ℤ⁺, mᵢ are pairwise coprime
cᵢ: c₁, …, cₖ ∈ ℤ

Statement:

    x ≡ c₁ (mod m₁)
    ⋮
    x ≡ cₖ (mod mₖ)

    The solution is: x (mod ∏mᵢ)
"""
function find_with_matching_remainders(congruences)
    c₁, m₁ = congruences[1]

    x = c₁
    m = m₁
    for (cᵢ, mᵢ) in Iterators.drop(congruences, 1)
        while x % mᵢ != cᵢ
            x += m
        end
        m *= mᵢ
    end
    x
end

function find_bus_departure_with_matching_offsets(buses)
    numbers = [
        (remainder = (b - (i - 1) % b) % b, mod = b)
        for (i, b) in enumerate(buses) if b !== missing
    ]

    find_with_matching_remainders(numbers)
end

function readfile()
    open("$(@__DIR__)/../../input") do f
        earliest = parse(Int, readline(f))
        buses = [b == "x" ? missing : parse(Int, b) for b in split(readline(f), ",")]
        (earliest, buses)
    end
end


function run()
    earliest, buses = readfile()

    @time result = *(find_bus(earliest, buses)...)
    println("The ID of the earliest bus you can take to the airport multiplied by the number of minutes you'll need to wait for that bus is $(result)")

    @time result = find_bus_departure_with_matching_offsets(buses)
    println("The earliest timestamp such that all of the listed bus IDs depart at offsets matching their positions in the list is $(result)")
end
end
