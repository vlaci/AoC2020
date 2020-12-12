using day12
using Test



@testset "Rain Risk" begin
    input = split(
        """
        F10
        N3
        F7
        R90
        F11""",
        "\n",
    )

    ins = map(Instruction, input) |> collect
    @test ins == [Forward(10), North(3), Forward(7), Right(90), Forward(11)]

    f0 = Ferry()
    f = execute_all(f0, ins)

    @test distance(f0, f) == 25

    f0 = FerryWithWaypoint()
    f = execute_all(f0, ins)

    @test distance(f0, f) == 286
end
