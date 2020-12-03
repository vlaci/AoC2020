using Test
include("../src/day03.jl")

using day03: parsetrees, counttrees


@testset "Tobogan trees" begin
    trees = split("""
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#""")
    t = parsetrees(trees)
    d = (3, 1)
    @test counttrees(t, d) == 7
end
