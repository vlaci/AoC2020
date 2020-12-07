module day07
using DataStructures

function readfile()
    open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
end

function parse_rules(rules)
    rv = []
    for rule in rules
        container = match(r"^(?P<container>[\w ]+) bags contain", rule)
        contents = eachmatch(r"(?P<num>\d+) (?P<content>[\w ]+) bags?", rule)

        push!(
            rv,
            (
                container = container[:container],
                contents = [
                    (num = parse(Int, c[:num]), content = c[:content]) for c in contents
                ],
            ),
        )
    end
    rv
end

function get_content_mapping(rules)
    ruledict = MultiDict()
    for (container, contents) in rules
        for (num, content) in contents
            insert!(ruledict, content, container)
        end
    end
    ruledict
end

function count_containers(rules, content)
    content_mapping = get_content_mapping(rules)
    touched = Set()
    function path(v)
        c = setdiff(get(content_mapping, v, []), touched)
        union!(touched, c)
        for content in c
            path(content)
        end
    end

    path(content)

    length(touched)
end

function get_container_mapping(rules)
    Dict(container => contents for (container, contents) in rules)
end

function count_contents(rules, container)
    container_mapping = get_container_mapping(rules)

    function path(v)
        total = 0
        for (num, content) in get(container_mapping, v, [])
            total += num + num * path(content)
        end
        total
    end

    path(container)
end

function run()
    rules = parse_rules(readfile())

    result = count_containers(rules, "shiny gold")
    println("The number of bag colors that can be used is $(result)")

    result = count_contents(rules, "shiny gold")
    println("The number of bagsis $(result)")
end
end
