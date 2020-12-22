using day22
using Test

@testset "Crab Combat" begin
    input = """
            Player 1:
            9
            2
            6
            3
            1

            Player 2:
            5
            8
            4
            7
            10
            """

    state = parse_input(input)
    winner, score = play_game(state)
    @test winner == :player2
    @test score == 306

    winner, score = play_game(state, play_round = recursive_combat)
    @test score == 291
end
