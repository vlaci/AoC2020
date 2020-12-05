#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day05.jl")

day05.run()
