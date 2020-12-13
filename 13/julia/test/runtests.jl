using day13
using Test


@testset "Shuttle Search" begin
    earliest = 939
    buses = [7, 13, missing, missing, 59, missing, 31, 19]
    @test find_bus(earliest, buses) == (departsin = 5, number = 59)

    @test find_bus_departure_with_matching_offsets(buses) == 1068781

    @test find_bus_departure_with_matching_offsets([17, missing, 13, 19]) == 3417
    @test find_bus_departure_with_matching_offsets([67, 7, 59, 61]) == 754018
    @test find_bus_departure_with_matching_offsets([67, missing, 7, 59, 61]) == 779210
    @test find_bus_departure_with_matching_offsets([67, 7, missing, 59, 61]) == 1261476
    @test find_bus_departure_with_matching_offsets([1789, 37, 47, 1889]) == 1202161486

end
