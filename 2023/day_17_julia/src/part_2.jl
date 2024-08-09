module Part2

import DataStructures
import Graphs
import SimpleWeightedGraphs

const filename = "input"

function main()
    inputfile = open(filename, "r")
    input = read(inputfile, String)

    graph = construct_graph(input)
    num_verts = Graphs.nv(graph)

    path = Graphs.Experimental.ShortestPaths.shortest_paths(graph, num_verts - 1, num_verts, Graphs.Experimental.ShortestPaths.AStar())
    path_len = get_path_len(graph, path)

    print("Part 2 final total: ")
    println(path_len)

    close(inputfile)
end

function get_path_len(graph::SimpleWeightedGraphs.SimpleWeightedDiGraph, path_res::Graphs.Experimental.ShortestPaths.ShortestPathResult)::Int
    path = Graphs.Experimental.ShortestPaths.paths(path_res)[1]
    total::Int = 0
    i = 1
    while (i < length(path))
        weight = SimpleWeightedGraphs.get_weight(graph, path[i], path[i+1])
        total += weight
        i += 1
    end
    return total - 2
end

function construct_graph(input::String)::SimpleWeightedGraphs.SimpleWeightedDiGraph
    # ::Graphs.DiGraph
    lines = filter(!isempty, split(input, "\n"))
    num_lines = length(lines)
    line_len = length(lines[1])
    line_stride = line_len * 2

    # Vertex order:
    # 1. Vertex with edges to horizontals
    # 2. Vertex with edges to verticals

    sources::Vector{Int} = []
    dests::Vector{Int} = []
    weights::Vector{Int} = []
    for (line_num, line) in enumerate(lines)
        lines_offset = (line_num - 1) * line_len
        for (char_num, _) in enumerate(line)
            curr_ver_vert_num = 1 + 2 * (lines_offset + char_num - 1)
            curr_hor_vert_num = curr_ver_vert_num + 1
            weight::UInt64 = 0
            # DRY be damned
            for i in 4:10
                # Right
                if (char_num + i <= line_len)
                    weight = 0
                    for j in 1:i
                        weight += line[char_num+j] - '0'
                    end
                    push!(sources, curr_ver_vert_num)
                    push!(dests, curr_ver_vert_num + 2 * i + 1)
                    push!(weights, weight)
                end
                # Left
                if (char_num > i)
                    weight = 0
                    for j in 1:i
                        weight += line[char_num-j] - '0'
                    end
                    push!(sources, curr_ver_vert_num)
                    push!(dests, curr_ver_vert_num - (i - 1) * 2 - 1)
                    push!(weights, weight)
                end
                # Down
                if (line_num + i <= num_lines)
                    weight = 0
                    for j in 1:i
                        weight += lines[line_num+j][char_num] - '0'
                    end
                    push!(sources, curr_hor_vert_num)
                    push!(dests, curr_hor_vert_num + i * line_stride - 1)
                    push!(weights, weight)
                end
                # Up
                if (line_num > i)
                    weight = 0
                    for j in 1:i
                        weight += lines[line_num-j][char_num] - '0'
                    end
                    push!(sources, curr_hor_vert_num)
                    push!(dests, curr_hor_vert_num - i * line_stride - 1)
                    push!(weights, weight)
                end
            end
        end
    end

    graph = SimpleWeightedGraphs.SimpleWeightedDiGraph(sources, dests, weights)
    num_regular_verts = Graphs.nv(graph)

    # Start vertex
    @assert Graphs.add_vertex!(graph)
    @assert Graphs.add_edge!(graph, num_regular_verts + 1, 1, 1)
    @assert Graphs.add_edge!(graph, num_regular_verts + 1, 2, 1)

    # End Vertex
    @assert Graphs.add_vertex!(graph)
    @assert Graphs.add_edge!(graph, num_regular_verts, num_regular_verts + 2, 1)
    @assert Graphs.add_edge!(graph, num_regular_verts - 1, num_regular_verts + 2, 1)

    return graph

end

end # module Part1
