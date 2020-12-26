using day07: parse_rules, count_containers, count_contents, get_content_mapping, MultiDict
using Test

@testset "Handy Haversacks" begin
    rules = parse_rules(split(
        """
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.""",
        "\n",
    ))

    @test rules[1] == (
        container = "light red",
        contents = [
            (num = 1, content = "bright white"),
            (num = 2, content = "muted yellow"),
        ],
    )
    @test get_content_mapping([rules[1]]) ==
          MultiDict("muted yellow" => "light red", "bright white" => "light red")

    @test count_containers(rules, "shiny gold") == 4
    @test count_contents(rules, "shiny gold") == 32

    rules = parse_rules(split(
        """
        shiny gold bags contain 2 dark red bags.
        dark red bags contain 2 dark orange bags.
        dark orange bags contain 2 dark yellow bags.
        dark yellow bags contain 2 dark green bags.
        dark green bags contain 2 dark blue bags.
        dark blue bags contain 2 dark violet bags.
        dark violet bags contain no other bags.""",
        "\n",
    ))

    @test count_contents(rules, "shiny gold") == 126
end
