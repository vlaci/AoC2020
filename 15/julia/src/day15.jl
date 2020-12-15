module day15

export play_game

function play_game(numbers; until = 2020)
    last_round = Dict{Int,Int}()
    round = 1
    for n in numbers
        last_round[n] = round
        round += 1
    end

    previous = round - 1
    l = last(numbers)
    while round <= until
        n = round - 1 - previous
        previous = get(last_round, n, round)
        last_round[n] = round
        l = n
        round += 1
    end
    l
end

function run()
    result = play_game([1, 0, 15, 2, 10, 13])
    println("The 2020th number spoken will be $(result)")
    @time result = play_game([1, 0, 15, 2, 10, 13]; until = 30000000)
    println("The 30000000th number spoken will be $(result)")
end
end
