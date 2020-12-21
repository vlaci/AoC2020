module day21

export all_ingredients, parse_input, count_occurrences, get_allergenics, as_canonical

function parse_input(input)
    input = input |> strip
    rv = Vector()
    for line in split(input, "\n")
        m = match(r"(?P<ingredients>(\w+ *)+) \(contains (?P<allergens>(\w+,* *)+)\)", line)
        ingredients = split(m[:ingredients], " ")
        allergens = split(m[:allergens], ", ")
        push!(rv, Set(allergens) => Set(ingredients))
    end
    rv
end

function all_ingredients(label)
    rv = Set()
    for (_, v) in label
        union!(rv, v)
    end
    rv
end

function allergens(label)
    ai = Dict()
    for (allergens, ingredients) in label
        for a in allergens
            i = get(ai, a, [])
            push!(i, ingredients)
            ai[a] = i
        end
    end
    ai
end

function get_allergenics(label)
    known = Dict()
    all_count = length(allergens(label))

    ai = allergens(label)
    while length(known) < all_count
        for (allergen, ingredients) in ai
            common_ingredients = ingredients[1] |> Set
            intersect!(common_ingredients, ingredients[2:end]...)

            if length(common_ingredients) == 1
                ingredient = only(common_ingredients)
                known[ingredient] = allergen
                remove!(ai, ingredient)
            end
        end
    end

    known
end

function remove!(label, ingredient)
    for ingredients in label |> values
        for i in ingredients
            delete!(i, ingredient)
        end
    end
end

function count_occurrences(label, ingredients)
    all_ingredients = []
    for (_, v) in label
        append!(all_ingredients, v)
    end

    sum(count(i -> i == ingredient, all_ingredients) for ingredient in ingredients)
end

function as_canonical(allergenic)
    join(first.(sort(allergenic |> collect, by = kv -> kv.second)), ",")
end

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end

function run()
    label = readfile() |> parse_input

    ingredients = all_ingredients(label)
    allergenic = get_allergenics(label)
    non_allergenic = setdiff(ingredients, allergenic)
    result = count_occurrences(label, non_allergenic)
    println("The number of times non-allergenic ingredients appear is $(result)")
    result = as_canonical(allergenic)
    println("The canonical dangerous ingredient list is '$(result)'")
end
end
