include("../src/day08.jl")
using Test


@testset "Handheld Halting" begin
    program = day08.load_program(split(
        """
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6""",
        "\n",
    ))
    @test day08.eval_program(program) == (5, false)

    @test day08.repair_program(program) == 8
end
