using day25
using Test

@testset "Combo Breaker" begin
    @test bruteforce(5764801) == 8
    @test pubkey(8) == 5764801
    @test enckey(8, 17807724) == 14897079
end
