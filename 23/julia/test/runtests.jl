using day23
using Test

@testset "Crab Cups" begin
    input = "389125467"
    cups = parsecups(input)

    @test play(cups, moves = 10) |> label == "92658374"
    @test play(cups) |> label == "67384529"

    cups = tomillion(cups)
    result = from1(play(cups, moves = 10^7), count = 2)

    @test result[1] * result[2] == 149245887792
end
