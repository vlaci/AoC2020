module day04

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end


function parsepassports(passports)
    map(parsepassport, split(passports, "\n\n"))
end

function parsepassport(passport)
    Dict(
        m[:key] => m[:value]
        for m in eachmatch(r"(?P<key>\w+):(?P<value>[^\s]+)", passport)
    )
end

function hasrequiredfields(passport)
    #=
    byr (Birth Year)
    iyr (Issue Year)
    eyr (Expiration Year)
    hgt (Height)
    hcl (Hair Color)
    ecl (Eye Color)
    pid (Passport ID)
    cid (Country ID)
    =#
    required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    issubset(required, keys(passport))
end

function isvalid(passport)
    #=

    byr (Birth Year) - four digits; at least 1920 and at most 2002.
    iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    hgt (Height) - a number followed by either cm or in:
        If cm, the number must be at least 150 and at most 193.
        If in, the number must be at least 59 and at most 76.
    hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    pid (Passport ID) - a nine-digit number, including leading zeroes.
    cid (Country ID) - ignored, missing or not.
    =#
    fields = Dict(
        "byr" => v -> occursin(r"^\d{4}$", v) && 1920 <= parse(Int, v) <= 2002,
        "iyr" => v -> occursin(r"^\d{4}$", v) && 2010 <= parse(Int, v) <= 2020,
        "eyr" => v -> occursin(r"^\d{4}$", v) && 2020 <= parse(Int, v) <= 2030,
        "hgt" => function (v)
            m = match(r"^(?P<height>\d{1,3})(?P<unit>cm|in)$", v)
            if isnothing(m)
                false
            elseif m[:unit] == "cm"
                150 <= parse(Int, m[:height]) <= 193
            elseif m[:unit] == "in"
                59 <= parse(Int, m[:height]) <= 76
            else
                false
            end
        end,
        "hcl" => v -> occursin(r"^\#[0-9a-f]{6}$", v),
        "ecl" => v -> occursin(r"^amb|blu|brn|gry|grn|hzl|oth$", v),
        "pid" => v -> occursin(r"^\d{9}$", v),
    )

    rv = [v(passport[k]) for (k, v) in fields] |> all
end

countvalid(passports) = length(filter(p -> hasrequiredfields(p) && isvalid(p), passports))

counthasrequiredfields(passports) = length(filter(hasrequiredfields, passports))

function run()
    passports = parsepassports(readfile())

    println("The number of passports with required fields: $(counthasrequiredfields(passports))")
    println("The number of passports with valid fields: $(countvalid(passports))")
end

end
