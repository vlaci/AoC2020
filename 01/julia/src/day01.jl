module day01

function read()
    lines = open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
    parse.(Int, lines)
end

function sum2020(coins)
    for i in coins, j in coins
        if i+j == 2020
            return i*j
        end
    end
end

function sum2020_2(coins)
    for i in coins, j in coins, k in coins
        if i+j+k == 2020
            return i*j*k
        end
    end
end

function run()
    coins = read()
    println("The answer to the first part is $(sum2020(coins))")
    println("The answer to the second part is $(sum2020_2(coins))")
end

end
