using day21
using Test


@testset "Allergen Assessment" begin
    input = """
            mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
            trh fvjkl sbzzf mxmxvkd (contains dairy)
            sqjhc fvjkl (contains soy)
            sqjhc mxmxvkd sbzzf (contains fish)
            """
    label = parse_input(input)
    allergenic = get_allergenics(label)

    @test setdiff(all_ingredients(label), allergenic) ==
          Set(["kfcds", "nhms", "sbzzf", "trh"])
    @test count_occurrences(label, Set(["kfcds", "nhms", "sbzzf", "trh"])) == 5
    @test as_canonical(allergenic) == "mxmxvkd,sqjhc,fvjkl"
end
