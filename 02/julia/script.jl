#!/usr/bin/env julia
using Pkg
Pkg.activate(@__DIR__)

include("src/day02.jl")

day02.run()
