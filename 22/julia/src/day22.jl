#!/usr/bin/env julia
module day22

export parse_input, play_game, recursive_combat

const State = @NamedTuple begin
    player1::Vector{Int}
    player2::Vector{Int}
end

function parse_input(input)
    player1, player2 = [split(p, "\n") for p in split(strip(input), "\n\n")]

    State((parse.(Int, player1[2:end]), parse.(Int, player2[2:end])))
end

function draw(state)
    (state.player1[1], state.player2[1]), State((state.player1[2:end], state.player2[2:end]))
end

function has_winner(state)
    if isempty(state.player1)
        return :player2
    elseif isempty(state.player2)
        return :player1
    end
end

function highest_drawn_wins(state)
    (card1, card2), state = draw(state)
    if card1 > card2
        State(([state.player1; [card1, card2]], state.player2))
    else
        State((state.player1, [state.player2; [card2, card1]]))
    end
end

function recursive_combat(state)
    if state.player1[1] > length(state.player1) - 1 ||
       state.player2[1] > length(state.player2) - 1
        return highest_drawn_wins(state)
    end

    (card1, card2), state = draw(state)
    subgame = State((state.player1[1:card1], state.player2[1:card2]))
    winner, _ = play_game(subgame; play_round = highest_drawn_wins)

    if winner == :player1
        State(([state.player1; [card1, card2]], state.player2))
    else
        State((state.player1, [state.player2; [card2, card1]]))
    end
end

function play_game(state; play_round = highest_drawn_wins)
    history = Set{State}()
    while (winner = has_winner(state); isnothing(winner))
        if state in history
            winner = :player1
            break
        end
        push!(history, state)
        state = play_round(state)
    end
    winner, calculate_score(getproperty(state, winner))
end

function calculate_score(deck)
    s = 0
    for (i, c) in enumerate(deck)
        s += (length(deck) - i + 1) * c
    end
    s
end

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end

function run()
    state = readfile() |> parse_input

    winner, score = play_game(state)
    println("$(String(winner)) wins with score $(score)")

    winner, score = play_game(state; play_round = recursive_combat)
    println("$(String(winner)) wins with score $(score)")
end

if abspath(PROGRAM_FILE) == @__FILE__
    using Pkg
    Pkg.activate(dirname(@__DIR__))
    run()
end
end
