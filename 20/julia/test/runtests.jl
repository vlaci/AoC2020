#using day20
using Test

struct Tile
    id::Int
    tile::Matrix{Char}
end

function Tile(input)
    lines = split(input, "\n")
    m = match(r"Tile (?P<id>\d+):", lines[1])
    id = parse(Int, m[:id])
    chars = [collect(l) for l in lines[2:end]]
    Tile(id, hcat(chars...))
end

function load_tiles(input)
    Tile.(split(strip(input), "\n\n"))
end

function Base.show(io::IO, tile::Tile)
    print(io, "T:$(tile.id)")
end

function rotate(tile::Tile)
    Tile(tile.id, rotr90(tile.tile, 1))
end

function edges(tile::Tile)
    t = tile.tile[:,1]
    r = tile.tile[end,:]
    b = tile.tile[:, end]
    l = tile.tile[1,:]
    (top=t, right=r, bottom=b, left=l)
end

mutable struct Transformation
    rotates::Int
    flip::Bool
    Transformation(r, f) = new(r%4, f)
end
function Base.show(io::IO, tr::Transformation)
    trs = []
    if tr.rotates > 0
        push!(trs, "rot $(tr.rotates*90)°")
    end
    if tr.flip
        push!(trs, "flip")
    end
    if isempty(trs)
        print(io, "Tr(ident)")
    else
        print(io, "Tr($(join(trs, ", ")))")
    end
end

Transformation() = Transformation(0, false)

function Base.:(+)(tr::Transformation, other::Transformation)
    @show tr, other
    rotates = other.rotates
    if tr.flip
        rotates = 4 - rotates
    end
    Transformation(tr.rotates + rotates, tr.flip ⊻ other.flip)
end

function rotate(n::Int)
    Transformation(n, false)
end

function rotate(t::Transformation, n)
    Transformation((t.rotates + n) % 4, t.flip)
end

function flip(t::Transformation)
    Transformation(t.rotates, !t.flip)
end

function flip()
    Transformation(0, true)
end

function transform(tile::Tile, tr::Transformation)
    t = tile.tile
    t = rotr90(t, tr.rotates)
    if tr.flip
        t=reverse(t, dims=1)
    end
    Tile(tile.id, t)
end

function inverse(tr::Transformation)
    rv = Transformation(tr.flip ? tr.rotates : 4-tr.rotates, tr.flip)
    println("==== $(tr) -> $(rv)")
    rv
end

const transforms = [Transformation(r, f) for f=false:true, r=0:3]

function connections(tile::Tile, other::Tile)
    (ttop, tright, tbottom, tleft) = edges(tile)
    rv = Dict()
    for tr in transforms
        (otop, oright, obottom, oleft) = edges(transform(other, tr))
        if ttop == obottom
            rv[:top] = tr
        elseif tright == oleft
            rv[:right] = tr
        elseif tbottom == otop
            rv[:bottom] = tr
        elseif tleft == oright
            rv[:left] = tr
        end
    end
    rv
end


mutable struct Neighbours
    tile::Tile
    neigh::Dict{Symbol, Union{Tuple,Nothing}}
end

Neighbours(tile) = Neighbours(tile, Dict(:top => nothing, :right => nothing, :bottom => nothing, :left=>nothing))

function neighbours(neigh::Neighbours, dir)
    get(neigh.neigh, dir, missing)
end


function Base.length(neigh::Neighbours)
    count(n->!isnothing(n), values(neigh.neigh))
end


function find_connections(tiles)
    rv = Dict()
    for i=1:length(tiles)
        ts = copy(tiles)
        t = popat!(ts, i)
        neigh = Neighbours(t)
        for o in ts
            conn = connections(t, o)
            for (dir, tr) in conn
                neigh.neigh[dir] = (o.id, tr)
            end
        end
        rv[t.id] = neigh
    end
    rv
end

function get_corners(tiles)
    matches = find_connections(tiles)
    first.(filter(kv->length(kv.second)==2, matches |> collect))
end

next_dirs = Dict(:top=>:right, :right=>:bottom, :bottom=>:left, :left=>:top)
flip_dirs = Dict(:top=>:bottom, :right=>:right, :bottom=>:top, :left=>:left)
function transformdir(dir, transform)
    rv = dir
    for i=1:transform.rotates
        rv=next_dirs[rv]
    end
    if transform.flip
        rv = flip_dirs[rv]
    end
    @show rv, dir, transform
    rv
end

function transform(neigh, tr)
    inv = inverse(tr)
    newtile = transform(neigh.tile, tr)
    new = Neighbours(newtile)
    for (dir, nb) in neigh.neigh
        if isnothing(nb)
            continue
        end
        nid, ntrans = nb
        new.neigh[transformdir(dir, inv)] = (nid, tr+ntrans)
        #n = connections[nid]
        #transform!(n, transforms, connections)
    end
    new
end

function assemble(tiles)
    l = sqrt(tiles |> length) |> Int
    image = Matrix(undef, l, l)
    connections = find_connections(tiles)
    corners = last.(filter(kv->length(kv.second)==2, connections |> collect))

    @show current = popfirst!(corners)

    while neighbours(current, :bottom) === nothing || neighbours(current, :right) === nothing
        @show current = popfirst!(corners)
    end

    in_position = Set()
    for j=1:l
        head = current
        for i=1:l
            image[i, j]=current.tile
            push!(in_position, current.tile.id)
            display(image)
            @show current
            if i < l
                @show nextid, tr = neighbours(current, :bottom)
                next = connections[nextid]

                connections[nextid] = transform(next, tr)
                current = connections[nextid]
            end
        end
        if j < l
            @show nextid, tr = neighbours(head, :right)
            connections[nextid] = transform(connections[nextid], tr)
            current = connections[nextid]
        end
    end
    display(connections)
    image
end

@testset "Jurassic Jigsaw" begin
  input =
  """
  Tile 2311:
  ..##.#..#.
  ##..#.....
  #...##..#.
  ####.#...#
  ##.##.###.
  ##...#.###
  .#.#.#..##
  ..#....#..
  ###...#.#.
  ..###..###

  Tile 1951:
  #.##...##.
  #.####...#
  .....#..##
  #...######
  .##.#....#
  .###.#####
  ###.##.##.
  .###....#.
  ..#.#..#.#
  #...##.#..

  Tile 1171:
  ####...##.
  #..##.#..#
  ##.#..#.#.
  .###.####.
  ..###.####
  .##....##.
  .#...####.
  #.##.####.
  ####..#...
  .....##...

  Tile 1427:
  ###.##.#..
  .#..#.##..
  .#.##.#..#
  #.#.#.##.#
  ....#...##
  ...##..##.
  ...#.#####
  .#.####.#.
  ..#..###.#
  ..##.#..#.

  Tile 1489:
  ##.#.#....
  ..##...#..
  .##..##...
  ..#...#...
  #####...#.
  #..#.#.#.#
  ...#.#.#..
  ##.#...##.
  ..##.##.##
  ###.##.#..

  Tile 2473:
  #....####.
  #..#.##...
  #.##..#...
  ######.#.#
  .#...#.#.#
  .#########
  .###.#..#.
  ########.#
  ##...##.#.
  ..###.#.#.

  Tile 2971:
  ..#.#....#
  #...###...
  #.#.###...
  ##.##..#..
  .#####..##
  .#..####.#
  #..#.#..#.
  ..####.###
  ..#.#.###.
  ...#.#.#.#

  Tile 2729:
  ...#.#.#.#
  ####.#....
  ..#.#.....
  ....#..#.#
  .##..##.#.
  .#.####...
  ####.#.#..
  ##.####...
  ##..#.##..
  #.##...##.

  Tile 3079:
  #.#.#####.
  .#..######
  ..#.......
  ######....
  ####.#..#.
  .#...#.##.
  #.#####.##
  ..#.###...
  ..#.......
  ..#.###...
  """

  tiles = load_tiles(input)
  @test Set(get_corners(tiles)) == Set([1951, 3079, 2971, 1171])

  #@show assemble(tiles)
end
