using day10
using Test


@testset "Adapter Array" begin
    @test day10.windowed([1, 2, 3, 4], 2) |> collect == [[1, 2], [2, 3], [3, 4]]

    adapters = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]

    @test day10.adapter_distribution(adapters) == Dict(1 => 7, 3 => 5)
    @test day10.adapter_combinations(adapters) == 8

    adapters = [
        28,
        33,
        18,
        42,
        31,
        14,
        46,
        20,
        48,
        47,
        24,
        23,
        49,
        45,
        19,
        38,
        39,
        11,
        1,
        32,
        25,
        35,
        8,
        17,
        7,
        9,
        4,
        2,
        34,
        10,
        3,
    ]
    @test day10.adapter_distribution(adapters) == Dict(1 => 22, 3 => 10)
    @test day10.adapter_combinations(adapters) == 19208
end
