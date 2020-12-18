using day18
using Test


@testset "Operation Order" begin
    @test evalexpr("1 + 2 * 3 + 4 * 5 + 6") == 71
    @test evalexpr("2 * 3 + (4 * 5)") == 26
    @test evalexpr("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437
    @test evalexpr("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240
    @test evalexpr("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632

    @test evalexpr2("1 + 2 * 3 + 4 * 5 + 6") == 231
    @test evalexpr2("1 + (2 * 3) + (4 * (5 + 6))") == 51
    @test evalexpr2("2 * 3 + (4 * 5)") == 46
    @test evalexpr2("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445
    @test evalexpr2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669060
    @test evalexpr2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340

end
