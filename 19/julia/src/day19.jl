module day19

export parse_input, matches, count_matches

abstract type Rule end

struct ConstRule <: Rule
    rule::String
end

function matches(rule::ConstRule, str)
    startswith(str, rule.rule) ? [length(rule.rule)] : []
end

struct EitherRule <: Rule
    a::Rule
    b::Rule
end

function matches(rule::EitherRule, str)
    a = matches(rule.a, str)
    b = matches(rule.b, str)

    [a; b]
end

const RuleReference = Int
const Rules = Dict{RuleReference,Rule}

struct SequenceRule <: Rule
    rules::Rules
    sequence::Vector{RuleReference}
end

# Skip printing the embedded pointer to the rules dictionary to ease debugging
function Base.show(io::IO, p::SequenceRule)
    print(io, "SequenceRule(")
    show(io, p.sequence)
    print(io, ")")
end

function SequenceRule(rules::Rules, str::AbstractString)
    seq = map(split(str, " ")) do idx
        parse(Int, idx) + 1
    end

    SequenceRule(rules, seq)
end

function matches(rule::SequenceRule, str)
    history = Dict{RuleReference,Set}()
    rv = []

    while true
        matched_until = 0
        match = true
        for rule_reference in rule.sequence
            remainder = str[matched_until+1:end]
            if isempty(remainder)
                # We still have rules to match but consumed the input string
                # (input was too short to match pattern).
                match = false
                break
            end
            p = rule.rules[rule_reference]
            matched_lengths = matches(p, remainder)

            if length(matched_lengths) == 1
                # Fast path, no branching point.
                matched_until += matched_lengths[1]
            elseif length(matched_lengths) > 1
                # See if we were at this branching point before, store it in
                # the history in case this is the first time we arrive here.
                visited = get(history, rule_reference, Set{RuleReference}())
                history[rule_reference] = visited

                # possible branches we not yet visited
                branches = setdiff(matched_lengths, visited)
                if isempty(branches)
                    # We had matces for this rule, but already visited them all.
                    # Remove it from the history to signal that we have no
                    # possible branching points here.
                    # A possible performance improvement would be to store the
                    # failing branches between subpattern matches.
                    delete!(history, rule_reference)
                    match = false
                    break
                else
                    # Try first candidate
                    push!(visited, branches[1])
                    matched_until += branches[1]
                end
            else
                # no match
                match = false
                break
            end
        end
        if match
            push!(rv, matched_until)
        end
        if isempty(history)
            # no unvisited branches remained
            break
        end
    end
    rv
end

function matches(rules::Rules, str)
    m = matches(rules[1], str)
    get(m, 1, 0) == length(str)
end

function count_matches(rules, messages)
    count(m -> matches(rules, m), messages)
end

function parse_input(input)
    rulesstr, messages = split(strip(input), "\n\n")

    ruledefs = split(rulesstr, "\n")
    messages = split(messages, "\n")

    rules = Rules()

    for ruledef in ruledefs
        m = match(r"(?P<idx>\d+): (?P<def>.*)", ruledef)
        i = parse(Int, m[:idx])
        def = m[:def]
        either = split(def, " | ")
        if startswith(def, "\"") && endswith(def, "\"")
            # const
            rules[i+1] = ConstRule(def[2:end-1])
        elseif length(either) == 2
            rules[i+1] = EitherRule(
                SequenceRule(rules, either[1]), SequenceRule(rules, either[2])
            )
        else
            rules[i+1] = SequenceRule(rules, def)
        end
    end

    rules, messages
end

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end


function run()
    input = readfile()
    rules, messages = parse_input(input)

    result = count_matches(rules, messages)
    println("The mumber of messages completely match rule 0 is $(result)")

    input = replace(input, "8: 42" => "8: 42 | 42 8")
    input = replace(input, "11: 42 31" => "11: 42 31 | 42 11 31")
    rules, messages = parse_input(input)
    result = count_matches(rules, messages)
    println("The mumber of messages completely match rule 0 after the replacements is $(result)")
end
end
