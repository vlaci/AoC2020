using day03: parsetrees, counttrees
using Test


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
