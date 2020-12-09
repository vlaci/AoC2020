#!/usr/bin/env -S dotnet fsi
open System.IO

type Instruction =
    | Nop of int
    | Acc of int
    | Jmp of int
    static member FromString(s: string) =
        match s.Split(' ') with
        | [| op; arg |] ->
            let arg = int (arg)
            match op with
            | "nop" -> Nop(arg)
            | "acc" -> Acc(arg)
            | "jmp" -> Jmp(arg)
            | x -> invalidArg "s" x
        | _ -> invalidArg "s" s

type Program = Instruction array

let eval (program: Program) =
    let rec loop pc acc hist =
        if Set.contains pc hist then
            acc, false
        elif pc = Array.length program then
            acc, true
        else
            let hist = hist.Add(pc)
            match program.[pc] with
            | Nop (_) -> loop (pc + 1) acc hist
            | Acc (a) -> loop (pc + 1) (acc + a) hist
            | Jmp (a) -> loop (pc + a) acc hist

    loop 0 0 Set.empty

let repair (program: Program) =
    let candidates =
        program
        |> Array.indexed
        |> Array.filter (fun (_, i) ->
            match i with
            | Nop (_)
            | Jmp (_) -> true
            | _ -> false)
        |> Array.map (fun (pc, _) -> pc)

    seq {
        for c in candidates do
            let mutable p = program |> Array.copy
            let i = p.[c]
            match i with
            | Nop (a) -> p.[c] <- Jmp(a)
            | Jmp (a) -> p.[c] <- Nop(a)
            | _ -> ()

            let (acc, halted) = eval p
            if halted then yield acc
    }
    |> Seq.head


let input =
    Path.Join(__SOURCE_DIRECTORY__, "..", "input")

let program =
    input
    |> File.ReadLines
    |> Seq.map Instruction.FromString
    |> Array.ofSeq


let acc, _ = eval program
printfn "The value in acc before the second iteration is: %i" acc

let acc' = repair program
printfn "The value in acc after the program is fixed is: %i" acc'
