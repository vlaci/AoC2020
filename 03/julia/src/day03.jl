module day03

function readfile()
    lines = open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
    parsetrees(lines)
end

function parsetrees(strmap)
    trees = Set()
    w, h = 0, 0
    for (y, l) in enumerate(strmap)
        h = y
        for (x, c) in enumerate(l)
            w = x
            if c == '#'
                push!(trees, (x, y))
            end
        end
    end
    (map = trees, size = (w, h))
end

function counttrees(trees, direction)
    x, y = [1, 1]
    w, h = trees.size

    numtrees = 0

    while y < h
        x, y = (x + direction[1] - 1) % w + 1, y + direction[2]
        if (x, y) in trees.map
            numtrees += 1
        end
    end
    numtrees
end

function run()
    trees = readfile()
    direction = (3, 1)
    println("The answer to the first part is $(counttrees(trees, direction))")

    slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    total = map(d -> counttrees(trees, d), slopes) |> prod
    println("The answer to the second part is $(total)")
end

end
