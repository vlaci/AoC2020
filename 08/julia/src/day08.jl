module day08

function readfile()
    open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
end

function load_program(instructions)
    map(instructions) do ins
        op, arg = split(ins)
        (op = op, arg = parse(Int, arg))
    end
end

function eval_program(program)
    pc = 1
    acc = 0
    pc_history = Set()
    code = Dict(
        "nop" => a -> pc += 1,
        "acc" => a -> (acc += a; pc += 1),
        "jmp" => a -> pc += a,
    )
    halted = false
    while pc ∉ pc_history && !halted
        push!(pc_history, pc)
        op, arg = program[pc]
        code[op](arg)
        halted = pc == length(program) + 1
    end
    acc, halted
end

function repair_program(program)
    for candidate in (c for (c, ins) in enumerate(program) if ins.op in ["jmp", "nop"])
        p = copy(program)
        ins = p[candidate]

        if ins.op == "nop"
            p[candidate] = (op = "jmp", arg = ins.arg)
        elseif ins.op == "jmp"
            p[candidate] = (op = "nop", arg = ins.arg)
        end

        (acc, halted) = eval_program(p)
        if halted
            return acc
        end
    end
end

function run()
    program = readfile() |> load_program
    result, _ = eval_program(program)

    println("The value in acc before the second iteration is: $(result)")

    result = repair_program(program)
    println("The value in acc after the program is fixed is: $(result)")
end

end
