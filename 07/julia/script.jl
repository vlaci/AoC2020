#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day07.jl")

day07.run()
