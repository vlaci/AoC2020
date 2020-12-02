#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day01.jl")

day01.run()
