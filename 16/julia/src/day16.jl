module day16

export parse_notes, validate, decode_my_ticket

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end

function parse_notes(notes)
    sections = split(notes, "\n\n")
    fields = Dict()
    for l in split(sections[1], "\n")
        m = match(
            r"(?P<name>[^:]+): (?P<i1l>\d+)-(?P<i1h>\d+) or (?P<i2l>\d+)-(?P<i2h>\d+)",
            l,
        )
        fields[m[:name]] = [
            parse(Int, m[:i1l]):parse(Int, m[:i1h]),
            parse(Int, m[:i2l]):parse(Int, m[:i2h]),
        ]
    end
    my_ticket = [parse(Int, n) for n in split(split(sections[2], "\n")[2], ",")]
    tickets = []
    for l in split(strip(sections[3]), "\n")[2:end]
        push!(tickets, [parse(Int, n) for n in split(l, ",")])
    end
    (fields = fields, my_ticket = my_ticket, tickets = tickets)
end

function validate(notes)
    ranges = values(notes.fields) |> Iterators.flatten |> collect

    error_rate = 0
    valid_tickets = []
    for ticket in notes.tickets
        valid = true
        for n in ticket
            if !any(n in r for r in ranges)
                error_rate += n
                valid = false
            end
        end
        if valid
            push!(valid_tickets, ticket)
        end
    end
    (error_rate = error_rate, notes = (notes..., tickets = valid_tickets))
end

function decode_my_ticket(notes)
    # at the begining any field can be anything, construct a mapping of field
    # names to matching indices
    fields = Dict()
    tickets = hcat(notes.my_ticket, notes.tickets...)
    for (i, val) in enumerate(eachrow(tickets))
        for (f, ranges) in notes.fields
            if all(any(v in r for r in ranges) for v in val)
                l = get(fields, f, Set())
                push!(l, i)
                fields[f] = l
            end
        end
    end

    # iterate over the possibe field name to index mappings by the most
    # specific result first which hopefully points to a signle unambigous index.
    # The already assigned indices are removed from the followup entries
    assigned = Set()
    for (f, candidates) in sort(fields |> collect, by = p -> length(p.second))
        c = setdiff(candidates, assigned)
        if length(c) != 1
            error("Cannot determine fields")
        end
        c = pop!(c)
        fields[f] = c
        push!(assigned, c)
    end

    # Construct the ticket by derefencing the indices to their values
    ticket = Dict()
    for (f, i) in fields
        ticket[f] = notes.my_ticket[i]
    end
    ticket
end

function run()
    notes = readfile() |> parse_notes
    error_rate, notes = validate(notes)

    println("The ticket scanning error rate is $(error_rate)")

    ticket = decode_my_ticket(notes)
    result = filter(p -> startswith(p.first, "departure"), ticket) |> values |> prod
    println("The product of fields starting with departure is $(result)")
end
end
