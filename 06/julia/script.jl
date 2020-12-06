#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day06.jl")

day06.run()
