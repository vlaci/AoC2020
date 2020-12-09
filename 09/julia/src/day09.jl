module day09
using Combinatorics

function readfile()
    lines = open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
    parse.(Int, lines)
end

function find_exception(data, preamable_length)
    for i = 1:length(data)-preamable_length
        s = map(sum, combinations(data[i:i+preamable_length-1], 2))
        if data[i+preamable_length] ∉ s
            return (data[i+preamable_length], i + preamable_length)
        end
    end
end


function find_weakness(data, exc_index)
    exc = data[exc_index]
    for n = 2:exc_index-1, i = 1:exc_index-n
        r = data[i:i+n-1]
        if exc == sum(r)
            return minimum(r) + maximum(r)
        end
    end
end

function run()
    data = readfile()
    result, i = find_exception(data, 25)
    println("The first exceptional number is $(result)")
    result = find_weakness(data, i)
    println("The encryption weakness is $(result)")
end
end
