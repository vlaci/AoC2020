using Test
include("../src/day02.jl")

using day02: parseline, passwordpolicy, passwordpolicy2

# 1-3 a: abcde
# 1-3 b: cdefg
# 2-9 c: ccccccccc
@testset "Line parsing" begin
    @test parseline("1-3 a: abcde") == (char = 'a', min = 1, max = 3, pwd = "abcde")
    @test parseline("1-3 b: cdefg") == (char = 'b', min = 1, max = 3, pwd = "cdefg")
    @test parseline("2-9 c: ccccccccc") == (char = 'c', min = 2, max = 9, pwd = "ccccccccc")
end


@testset "Password matching" begin
    @test passwordpolicy('a', 1, 3, "abcde") == true
    @test passwordpolicy('b', 1, 3, "cdefg") == false
    @test passwordpolicy('c', 2, 9, "ccccccccc") == true
end

@testset "Correct policy" begin
    # 1-3 a: abcde is valid: position 1 contains a and position 3 does not.
    # 1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
    # 2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.

    @test passwordpolicy2('a', 1, 3, "abcde") == true
    @test passwordpolicy2('b', 1, 3, "cdefg") == false
    @test passwordpolicy2('c', 2, 9, "ccccccccc") == false
end
