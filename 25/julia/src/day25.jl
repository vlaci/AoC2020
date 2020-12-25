#!/usr/bin/env julia
module day25

export enckey, bruteforce

M = 20201227

function enckey(priv, pub)
    powermod(pub, priv, M)
end

function bruteforce(pub)
    privkey = 1
    pubkey = 1
    while (pubkey = pubkey * 7 % M)  != pub
        privkey += 1
    end
    privkey
end

function readfile()
    parse.(Int, readlines("$(@__DIR__)/../../input"))
end

function run()
    pubkeys = readfile()
    privkey = bruteforce(pubkeys[1])
    result = enckey(privkey, pubkeys[2])
    println("The encryption key is $result")
end

if abspath(PROGRAM_FILE) == @__FILE__
    using Pkg
    Pkg.activate(dirname(@__DIR__))
    run()
end
end
