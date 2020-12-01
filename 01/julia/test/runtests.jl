using Test
include("../src/day01.jl")

@testset "Sum" begin
    @test day01.sum2020([1721, 979, 366, 299, 675, 1456], 2) == 514579

    @test day01.sum2020([1721, 979, 366, 299, 675, 1456], 3) == 241861950
end
