#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day11.jl")

day11.run()
