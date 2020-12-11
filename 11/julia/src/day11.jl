module day11

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end

function parse_map(m)
    chars = [collect(l) for l in split(strip(m), "\n")]
    hcat(chars...)
end

EMPTY = 'L'
OCCUPIED = '#'
FLOOR = '.'

function count_occupied(m, x, y, neighbours_only = true)
    if m[x, y] == FLOOR
        return 0
    end

    𝐷 = [(x, y) for x = -1:1, y = -1:1]

    occupied = 0

    for (𝑑x, 𝑑y) in 𝐷
        xᵢ, yᵢ = x, y
        xᵢ = xᵢ + 𝑑x
        yᵢ = yᵢ + 𝑑y

        distance = 1

        while 1 <= xᵢ <= size(m, 1) &&
                  1 <= yᵢ <= size(m, 2) &&
                  (xᵢ, yᵢ) != (x, y) &&
                  (neighbours_only && distance == 1 || !neighbours_only)
            s = m[xᵢ, yᵢ]
            if s == OCCUPIED
                occupied += 1
                break
            elseif s == EMPTY
                break
            end

            xᵢ = xᵢ + 𝑑x
            yᵢ = yᵢ + 𝑑y

            distance += 1
        end
    end
    occupied
end

function evolve(m, limit, count_occupied)
    rv = copy(m)
    for x = 1:size(m, 1), y = 1:size(m, 2)
        if m[x, y] == FLOOR
            continue
        end

        oc = count_occupied(m, x, y)
        if oc == 0
            rv[x, y] = OCCUPIED
        elseif oc >= limit
            rv[x, y] = EMPTY
        end
    end
    rv
end

function evolve_till_stable(m, limit, count_occupied)
    m1 = evolve(m, limit, count_occupied)
    while m1 != m
        m = m1
        m1 = evolve(m, limit, count_occupied)
    end
    m1
end


function run()
    seating = readfile() |> parse_map

    result = count(==(OCCUPIED), evolve_till_stable(seating, 4, count_occupied))
    println("The number of seats ending up occupied is $(result)")
    result = count(
        ==(OCCUPIED),
        evolve_till_stable(seating, 5, (m, x, y) -> count_occupied(m, x, y, false)),
    )
    println("The number of seats ending up occupied with the new visibility method is $(result)")
end
end
