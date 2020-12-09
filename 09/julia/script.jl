#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day09.jl")

day09.run()
