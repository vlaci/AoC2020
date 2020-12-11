include("../src/day11.jl")
using Test

@testset "Seating System" begin
    seating = """
        L.LL.LL.LL
        LLLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLLL
        L.LLLLLL.L
        L.LLLLL.LL"""

    s = day11.parse_map(seating)

    @test count(
        s -> s == day11.OCCUPIED,
        day11.evolve_till_stable(s, 4, day11.count_occupied),
    ) == 37
    @test count(
        s -> s == day11.OCCUPIED,
        day11.evolve_till_stable(s, 5, (m, x, y) -> day11.count_occupied(m, x, y, false)),
    ) == 26
end
