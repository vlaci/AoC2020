#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day04.jl")

day04.run()
