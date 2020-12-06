module day06

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end

function count_anyyes(formstr)
    forms = split(formstr, "\n\n")

    [Set(replace(f, "\n" => "")) |> length for f in forms] |> sum
end


function count_allyes(formstr)
    forms = split(formstr, "\n\n")

    total = 0
    for f in forms
        total += intersect([Set(l) for l in split(f)]...) |> length
    end
    total
end

function run()
    customsforms = readfile()
    yes = count_anyyes(customsforms)

    println("The sum of unique question answered with yes: $(yes)")
    yes = count_allyes(customsforms)
    println("The sum of questions where everyone ansered yes: $(yes)")
end

end
