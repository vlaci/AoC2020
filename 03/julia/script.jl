#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day03.jl")

day03.run()
