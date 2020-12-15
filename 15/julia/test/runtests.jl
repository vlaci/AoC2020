using day15
using Test


@testset "Rambunctious Recitation" begin
    numbers = [0, 3, 6]

    @test play_game(numbers, until = 4) == 0
    @test play_game(numbers, until = 5) == 3
    @test play_game(numbers, until = 6) == 3
    @test play_game(numbers, until = 7) == 1
    @test play_game(numbers, until = 8) == 0
    @test play_game(numbers, until = 9) == 4
    @test play_game(numbers, until = 10) == 0
    @test play_game(numbers) == 436

    @test play_game([1, 3, 2]) == 1
    @test play_game([2, 1, 3]) == 10
    @test play_game([1, 2, 3]) == 27
    @test play_game([2, 3, 1]) == 78
    @test play_game([3, 2, 1]) == 438
    @test play_game([3, 1, 2]) == 1836
end
