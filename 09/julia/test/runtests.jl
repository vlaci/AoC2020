include("../src/day09.jl")
using Test
using Combinatorics


@testset "Encoding Error" begin
    data = [
        35,
        20,
        15,
        25,
        47,
        40,
        62,
        55,
        65,
        95,
        102,
        117,
        150,
        182,
        127,
        219,
        299,
        277,
        309,
        576,
    ]

    @test day09.find_exception(data, 5) == (127, 15)
    @test day09.find_weakness(data, 15) == 62
end
