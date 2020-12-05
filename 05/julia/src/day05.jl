module day05

function readfile()
    open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
end

function to_seatid(bp)
    row = parse(Int, "0b" * replace(replace(bp[1:7], "F" => "0"), "B" => 1))
    col = parse(Int, "0b" * replace(replace(bp[8:10], "L" => "0"), "R" => 1))

    parse(Int, "0b" * replace(replace(bp, r"F|L" => "0"), r"B|R" => 1))
end


function run()
    bps = readfile()
    seatids = map(to_seatid, bps)
    println("The maximum seat ID is: $(seatids |> maximum)")

    sort!(seatids)
    result = -1
    for (i, id) in enumerate(seatids)
        if id != seatids[i+1] - 1
            result = id + 1
            break
        end
    end
    println("My seat ID is: $(result)")
end

end
