#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day12.jl")

day12.run()
