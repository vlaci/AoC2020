#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day08.jl")

day08.run()
