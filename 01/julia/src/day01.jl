module day01
using Combinatorics

function read()
    lines = open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
    parse.(Int, lines)
end

function sum2020(coins, count)
    for c in combinations(coins, count)
        if sum(c) == 2020
            return prod(c)
        end
    end
end

function run()
    coins = read()
    println("The answer to the first part is $(sum2020(coins, 2))")
    println("The answer to the second part is $(sum2020(coins, 3))")
end

end
