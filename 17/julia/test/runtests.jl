using day17
using Test

@testset "Conway Cubes" begin
    init = """
    .#.
    ..#
    ###"""

    s₀ = parse_init(init, dimensions = 3)
    s₆ = boot(s₀)
    @test length(s₆) == 112

    s₀ = parse_init(init, dimensions = 4)
    s₆ = boot(s₀)
    @test length(s₆) == 848
end
