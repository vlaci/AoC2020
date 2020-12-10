module day10

function readfile()
    lines = open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
    parse.(Int, lines)
end

function windowed(array, window_size)
    ((@view array[i:i+window_size-1]) for i = 1:length(array)-window_size+1)
end

function adapter_distribution(adapters)
    adapters = vcat([0], sort(adapters), [maximum(adapters) + 3])
    distrib = Dict()
    for (a, b) in windowed(adapters, 2)
        d = b - a
        distrib[d] = get(distrib, d, 0) + 1
    end
    distrib
end

function adapter_combinations(adapters)
    adapters = vcat([0], sort(adapters), [maximum(adapters) + 3])

    # Find all adapters which can be removed
    removable = [
        j
        for
        ((i, a), (j, x), (k, b)) in windowed(collect(enumerate(adapters)), 3) if b - a < 3
    ]

    # Measure all continous segments from which any adapter can be removed
    segments = []
    len = 0
    for (i, j) in windowed(removable, 2)
        len += 1
        if j - i > 1
            push!(segments, len)
            len = 0
        end
    end
    # Push the last item which hasn-t been accessed because of the window() function
    push!(segments, len + 1)

    map(segments) do len
        # Number of combinations how maximum of 2 elements
        # can be removed from a segment
        sum(binomial(len, b) for b in range(0, stop = min(2, len)))
    end |> prod  # independent choices are multiplied
end

function run()
    adapters = readfile()

    d = adapter_distribution(adapters)
    result = d[1] * d[3]
    println("The number of 1-jolt differences multiplied by the number of 3-jolt differences is $(result)")

    result = adapter_combinations(adapters)
    println("The total number of distinct ways you can arrange the adapters to connect the charging outlet to your device is $(result)")
end

end
