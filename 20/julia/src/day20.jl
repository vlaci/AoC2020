module day20

export load_tiles, get_corners, assemble, calculate_roughness

struct Tile
    id::Int
    tile::BitArray{2}
end

function Tile(input)
    lines = split(input, "\n")
    m = match(r"Tile (?P<id>\d+):", lines[1])
    id = parse(Int, m[:id])
    chars = [[c == '#' for c in l] for l in lines[2:end]]
    Tile(id, hcat(chars...))
end

function load_tiles(input)
    Tile.(split(strip(input), "\n\n"))
end

function Base.show(io::IO, tile::Tile)
    print(io, "T:$(tile.id)")
end

function edges(tile::Tile)
    t = tile.tile[:, 1]
    r = tile.tile[end, :]
    b = tile.tile[:, end]
    l = tile.tile[1, :]
    (top = t, right = r, bottom = b, left = l)
end

mutable struct Transformation
    rotates::Int
    flip::Bool
    Transformation(r, f) = new(r % 4, f)
end

const IdentTransformation = Transformation(0, false)
const AllTransformations = [Transformation(r, f) for f = false:true, r = 0:3]

function Base.:(==)(tr::Transformation, other::Transformation)
    tr.rotates == other.rotates && tr.flip == other.flip
end

function transform(M::AbstractMatrix, tr::Transformation)
    M = rotr90(M, tr.rotates)
    if tr.flip
        M = reverse(M, dims = 1)
    end
    M
end

function transform(tile::Tile, tr::Transformation)
    Tile(tile.id, transform(tile.tile, tr))
end


function connections(tile::Tile, other::Tile)
    (ttop, tright, tbottom, tleft) = edges(tile)
    rv = Dict()
    for tr in AllTransformations
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
    neigh::Dict{Symbol,Union{Tuple,Nothing}}
end

Neighbours(tile) = Neighbours(
    tile,
    Dict(:top => nothing, :right => nothing, :bottom => nothing, :left => nothing),
)

function neighbours(neigh::Neighbours, dir)
    get(neigh.neigh, dir, missing)
end

function Base.length(neigh::Neighbours)
    count(n -> !isnothing(n), values(neigh.neigh))
end

function find_connections(tiles)
    neighbours = Vector{Pair{Int,Neighbours}}(undef, length(tiles))
    Threads.@threads for i = 1:length(tiles)
        ts = copy(tiles)
        t = popat!(ts, i)
        neigh = Neighbours(t)
        for o in ts
            conn = connections(t, o)
            for (dir, tr) in conn
                neigh.neigh[dir] = (o.id, tr)
            end
        end
        neighbours[i] = t.id => neigh
    end
    Dict(neighbours)
end

function get_corners(tiles)
    matches = find_connections(tiles)
    # Corners have 2 conencting edges
    first.(filter(kv -> length(kv.second) == 2, matches |> collect))
end

function assemble(tiles)
    l = sqrt(tiles |> length) |> Int
    image = Matrix(undef, l, l)

    connections = find_connections(tiles)
    corners = last.(filter(kv -> length(kv.second) == 2, connections |> collect))

    # Find top-left corner first
    current = popfirst!(corners)
    while neighbours(current, :bottom) === nothing ||
        neighbours(current, :right) === nothing
        current = popfirst!(corners)
    end

    # Set-pieaces that no longer needed to be moved
    in_position = Set()

    # column by column
    for j = 1:l
        head = current
        # segment by segment
        for i = 1:l
            image[i, j] = current.tile
            push!(in_position, current.tile.id)

            # Not at the bottom of the column, find next segment
            if i < l
                nextid, tr = neighbours(current, :bottom)
                if tr != IdentTransformation
                    # We need to rotate the segment to match with the bottom
                    # edge of the current tile
                    next = transform(connections[nextid].tile, tr)

                    # Biggest performance hog ever: recalculate all remaining
                    # tiles connections with each-other to match with the one
                    # rotated tile
                    connections = find_connections([
                        # The tiles which aren't placed
                        [
                            nb.tile
                            for
                            nb in connections |> values if
                            nb.tile.id ∉ in_position ∪ [nextid, current.tile.id]
                        ]
                        # The just rotated tile
                        [next]
                    ])
                end
                current = connections[nextid]
            end
        end
        if j < l
            # It is the same as above: not at the last column, find the first
            # segment of the collumn to the right
            nextid, tr = neighbours(head, :right)
            if tr != IdentTransformation
                next = transform(connections[nextid].tile, tr)
                connections = find_connections([
                    [
                        nb.tile
                        for
                        nb in connections |> values if
                        nb.tile.id ∉ in_position ∪ [nextid, current.tile.id]
                    ]
                    [next]
                ])
            end
            current = connections[nextid]
        end
    end

    # Cut positioning edges
    image = map(t -> t.tile[2:end-1, 2:end-1], image)

    vcat([hcat(image[:, i]...) for i = 1:size(image, 2)]...)
end

function calculate_roughness(image)
    monster = [
        "                  # ",
        "#    ##    ##    ###",
        " #  #  #  #  #  #   "
    ]
    pixelcount = [count(c -> c == '#', l) for l in monster] |> sum
    pattern = [replace(l, ' ' => '.') |> Regex for l in monster]

    monsters = 0
    for tr in AllTransformations
        img = transform(image, tr)
        # Restore original image
        rows = [String(map(c -> c ? '#' : '.', r)) for r in eachrow(img)]

        for i = 1:length(rows)-2
            # Check for the last row of the monster as it is the longest
            offsets = [m.offset for m in eachmatch(pattern[2], rows[i+1], overlap = true)]

            for (j, startp) in offsets |> enumerate
                endp = startp + length(pattern[1].pattern)
                if match(pattern[1], rows[i][startp:endp]) !== nothing &&
                    match(pattern[3], rows[i+2][startp:endp]) !== nothing
                    # Other rows match at exactly the same vertical position
                    monsters += 1
                end
            end
        end
        if monsters > 0
            # Only one transformation contains monsters
            break
        end
    end

    count(image) - monsters * pixelcount
end

function readfile()
    open("$(@__DIR__)/../../input") do f
        read(f, String)
    end
end

function run()
    tiles = readfile() |> load_tiles
    corners = get_corners(tiles)

    result = reduce(*, corners)
    println("The product of the IDs of corner tiles is $(result)")
    @time image = assemble(tiles)
    @time result = calculate_roughness(image)
    println("The number of #s not part of a seamonster is $(result)")
end
end
