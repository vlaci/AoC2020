using day24
using Test

@testset "Lobby Layout" begin
    path = "esenee" |> parse_path
    @test path == [E, SE, NE, E]

    @test reduce((a, b) -> a .+ b, "nwwswee" |> parse_path) == (0, 0)

    input = """
            sesenwnenenewseeswwswswwnenewsewsw
            neeenesenwnwwswnenewnwwsewnenwseswesw
            seswneswswsenwwnwse
            nwnwneseeswswnenewneswwnewseswneseene
            swweswneswnenwsewnwneneseenw
            eesenwseswswnenwswnwnwsewwnwsene
            sewnenenenesenwsewnenwwwse
            wenwwweseeeweswwwnwwe
            wsweesenenewnwwnwsenewsenwwsesesenwne
            neeswseenwwswnwswswnw
            nenwswwsewswnenenewsenwsenwnesesenew
            enewnwewneswsewnwswenweswnenwsenwsw
            sweneswneswneneenwnewenewwneswswnese
            swwesenesewenwneswnwwneseswwne
            enesenwswwswneneswsenwnewswseenwsese
            wnwnesenesenenwwnenwsewesewsesesew
            nenewswnwewswnenesenwnesewesw
            eneswnwswnwsenenwnwnwwseeswneewsenese
            neswnwewnwnwseenwseesewsenwsweewe
            wseweeenwnesenwwwswnew
            """

    paths = parse_input(input)
    ts = tiles(paths)
    @test count_blacks(ts) == 10

    @test count_blacks(flip(ts)) == 15
    @test count_blacks(flip(ts, 100)) == 2208
end
