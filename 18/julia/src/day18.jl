module day18

export evalexpr, evalexpr2

function evalexpr(expr)
    tokens = Iterators.Stateful(tokenize(expr))
    next_token() = isempty(tokens) ? (EOT, 0) : popfirst!(tokens)

    acc = 0

    function eval_fact()
        type, val = next_token()
        if type in (DIGIT, EOT)
            val
        elseif type == LP
            eval()
        end
    end

    function eval()
        left = eval_fact()
        acc = left

        while true
            type, val = next_token()
            if type in (EOT, RP)
                break
            elseif type != OPER
                error("Syntax error, operation expected, got $(type) ($(val))")
            end
            if val == '+'
                acc += eval_fact()
            elseif val == '-'
                acc -= eval_fact()
            elseif val == '*'
                acc *= eval_fact()
            end
        end
        acc
    end

    eval()
end

function evalexpr2(expr)
    tokens = Iterators.Stateful(tokenize(expr))
    consume_token() = isempty(tokens) ? (EOT, 0) : popfirst!(tokens)
    peek_token() = isempty(tokens) ? (EOT, 0) : peek(tokens)

    function eval_fact()
        type, val = consume_token()
        if type in (DIGIT, EOT)
            val
        elseif type == LP
            eval()
        end
    end

    function eval_term()
        left = eval_fact()
        acc = left

        while true
            type, val = peek_token()

            if val == '+'
                consume_token()
                acc += eval_fact()
            elseif val == '-'
                consume_token()
                acc -= eval_fact()
            else
                break
            end
        end
        acc
    end

    function eval()
        left = eval_term()
        acc = left

        while true
            type, val = consume_token()
            if val == '*'
                acc *= eval_term()
            else
                break
            end
        end
        acc
    end

    eval()
end

function tokenize(expr)
    tokens = []
    for ch in expr
        if ch == '('
            push!(tokens, (LP, ch))
        elseif ch == ')'
            push!(tokens, (RP, ch))
        elseif ch in "+-*"
            push!(tokens, (OPER, ch))
        elseif ch in "0123456789"
            push!(tokens, (DIGIT, parse(Int, ch)))
        end
    end
    tokens
end

@enum TOKENS begin
    DIGIT
    OPER
    LP
    RP
    EOT
end


function readfile()
    open("$(@__DIR__)/../../input") do f
        readlines(f)
    end
end


function run()
    exprs = readfile()
    result = map(evalexpr, exprs) |> sum
    println("The sum of the resulting values is $(result)")
    result = map(evalexpr2, exprs) |> sum
    println("The sum of the resulting values with the new rules is $(result)")
end
end
