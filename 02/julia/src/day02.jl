module day02

function readfile()
    lines = open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
    parseline.(lines)
end

function parseline(line)
    m = match(r"(?P<min>\d+)-(?P<max>\d+) (?P<char>\w): (?P<pwd>\w+)", line)
    (
        char = m[:char][1],
        min = parse(Int, m[:min]),
        max = parse(Int, m[:max]),
        pwd = m[:pwd],
    )
end

function passwordpolicy(char, min, max, pwd)
    min <= count(c -> (c == char), pwd) <= max
end

function passwordpolicy2(char, pos1, pos2, pwd)
    pwd[pos1] == char && pwd[pos2] != char || pwd[pos1] != char && pwd[pos2] == char
end

function run()
    passwords = readfile()

    println("The answer to the first part is $(filter(p -> passwordpolicy(p...), passwords) |> length)")
    println("The answer to the second part is $(filter(p -> passwordpolicy2(p...), passwords) |> length)")
end

end
