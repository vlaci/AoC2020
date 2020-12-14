using day14
using Test

@testset "Docking Data" begin

    program = split(
        """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0""",
        "\n",
    )

    program = parse(Program, program)
    c = Computer()
    execute(c, program)
    @test sum(c |> memory |> values) == 165

    program = split(
        """
        mask = 000000000000000000000000000000X1001X
        mem[42] = 100
        mask = 00000000000000000000000000000000X0XX
        mem[26] = 1""",
        "\n",
    )

    program = parse(Program, program)
    c = ComputerV2()
    execute(c, program)
    @test sum(c |> memory |> values) == 208
end
