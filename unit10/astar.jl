# Demonstrates the A* algorithm for pathfinding
#
# 2024 by Ralf Herbrich
# Hasso Plattner Institut

using Plots
using Mazes
using DataStructures
using Random

# plots a maze on the screen
function plot_maze(maze;
    start=(1, 1),
    goal=(maze.r, maze.c),
    active=nothing,
    markersize=10,
    visited_list=[],
    path=[],
    wall_color="black",
    start_color="green",
    goal_color="blue",
    active_color="orange",
    visited_color="yellow",
    path_color="red",
)
    p = plot(legend=false, aspect_ratio=:equal, axis=([], false))

    # plot the visited (node) list
    for (r, c) in visited_list
        plot!(Shape([c, c, c + 1, c + 1], [maze.r - r, maze.r - r - 1, maze.r - r - 1, maze.r - r]), color=visited_color, linewidth=0)
    end

    # plot the active node
    if !isnothing(active)
        r, c = active
        plot!(Shape([c, c, c + 1, c + 1], [maze.r - r, maze.r - r - 1, maze.r - r - 1, maze.r - r]), color=active_color, linewidth=0)
    end

    # plot the path
    if !isempty(path)
        current = (0,0)
        for (r, c) in path
            if current != (0,0)
                plot!([current[2] + 0.5, c + 0.5], [maze.r - current[1] - 0.5, maze.r - r - 0.5], linewidth=3, color=path_color)
                current = (r, c)
            else
                current = (r, c)
            end
        end
    end
    
    # plot the start and goal
    if !isnothing(start)
        plot!([start[2] + 0.5], [maze.r - start[1] - 0.5], marker=:circle, markersize=markersize, color=start_color)
    end
    if !isnothing(goal)
        plot!([goal[2] + 0.5], [maze.r - goal[1] - 0.5], marker=:circle, markersize=markersize, color=goal_color)
    end

    # plot the maze walls
    for r = 1:maze.r
        for c = 1:maze.c
            if r == 1
                plot!([c, c + 1], [maze.r - 1, maze.r - 1], color=wall_color, linewidth=2)
            end
            if c == 1
                plot!([c, c], [maze.r - r, maze.r - r - 1], color=wall_color, linewidth=2)
            end
            if !(((r, c), (r, c + 1)) in maze.T.E)
                plot!([c + 1, c + 1], [maze.r - r, maze.r - r - 1], color=wall_color, linewidth=2)
            end
            if !(((r, c), (r + 1, c)) in maze.T.E)
                plot!([c, c + 1], [maze.r - r - 1, maze.r - r - 1], color=wall_color, linewidth=2)
            end
        end
    end

    return(p)
end

# implements the Manhattan distance heuristic
manhattan((x1,y1),(x2,y2)) = abs(x1-x2)+abs(y1-y2)

# implements the Euclidean distance heuristic
eucledian((x1,y1),(x2,y2)) = sqrt((x1-x2)^2 + (y1-y2)^2)

# implements the Euclidean distance heuristic
no_heuristic((x1,y1),(x2,y2)) = 0

# implements the A* algorithm
function astar(maze; start=(1,1), goal=(maze.r,maze.c), heuristic=manhattan)
    # local definition of neighbors based on the maze graph
    neighbors(node) = maze.T.N[node]

    # initialize the open list as well as the distance from the start and the path
    open_list = PriorityQueue{Tuple{Int, Int}, Int}()
    dist_from_start = Dict{Tuple{Int, Int}, Int}()
    came_from = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()

    for node in maze.T.V
        dist_from_start[node] = typemax(Int)
    end
    dist_from_start[start] = 0

    open_list[start] = dist_from_start[start] + heuristic(start, goal)

    # the main loop
    while !isempty(open_list)
        # find the node with the smallest f-value
        current = dequeue!(open_list)

        # check if we reached the goal and then reconstruct the path from start to goal
        if current == goal
            path = Vector{Tuple{Int, Int}}()
            while current != start
                push!(path, current)
                current = came_from[current]
            end
            push!(path, current)
            return reverse(path)
        end

        # if not the goal node, expand the current node
        for neighbor in neighbors(current)
            # if we get faster to the neighbor node via the current node than so far, update the distance and the path
            if dist_from_start[current] + 1 < dist_from_start[neighbor]
                came_from[neighbor] = current
                dist_from_start[neighbor] = dist_from_start[current] + 1
                open_list[neighbor] = dist_from_start[neighbor] + heuristic(neighbor, goal)
            end
        end
    end

    # if the open list is empty, we cannot reach the goal
    return nothing
end

# creates a movie from running the A* algorithm
function astar_movie(maze; start=(1,1), goal=(maze.r,maze.c), heuristic=manhattan)
    # allocate the animation object and the set of all visited nodes
    anim = Animation()
    visited = Set{Tuple{Int, Int}}()

    # local definition of neighbors based on the maze graph
    neighbors(node) = maze.T.N[node]

    # initialize the open list as well as the distance from the start and the path
    open_list = PriorityQueue{Tuple{Int, Int}, Float64}()
    dist_from_start = Dict{Tuple{Int, Int}, Int}()
    came_from = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()

    for node in maze.T.V
        dist_from_start[node] = typemax(Int)
    end
    dist_from_start[start] = 0

    open_list[start] = dist_from_start[start] + heuristic(start, goal)

    # the main loop
    while !isempty(open_list)
        # find the node with the smallest f-value
        current = dequeue!(open_list)

        # reconstruct the shortest path from start to current
        path = Vector{Tuple{Int, Int}}()
        node = current
        while node != start
            push!(path, node)
            node = came_from[node]
        end
        push!(path, node)

        # draw the maze
        p = plot_maze(maze, visited_list=collect(visited), active=current, markersize=3, path=reverse(path))
        frame(anim, p)
        
        # check if we reached the goal and then reconstruct the path from start to goal
        if current == goal
            # path = Vector{Tuple{Int, Int}}()
            # while current != start
            #     push!(path, current)
            #     current = came_from[current]
            # end
            # push!(path, current)

            # # draw the final maze
            # p = plot_maze(maze, visited_list=collect(visited), active=goal, markersize=3, path=reverse(path))
            # frame(anim, p)
            return anim
        end

        # if not the goal node, expand the current node
        for neighbor in neighbors(current)
            # if we get faster to the neighbor node via the current node than so far, update the distance and the path
            if dist_from_start[current] + 1 < dist_from_start[neighbor]
                came_from[neighbor] = current
                dist_from_start[neighbor] = dist_from_start[current] + 1
                open_list[neighbor] = dist_from_start[neighbor] + heuristic(neighbor, goal)
            end
        end

        # add the current node to the visited set
        push!(visited, current)
    end

    # if the open list is empty, we cannot reach the goal
    return anim
end


Random.seed!(42)
mz = Maze(15, 15)
mp4(astar_movie(mz, heuristic=manhattan), "~/Downloads/astar_manhattan.mp4", fps = 12, loop = 0)
mp4(astar_movie(mz, heuristic=eucledian), "~/Downloads/astar_euclidean.mp4", fps = 12, loop = 0)
mp4(astar_movie(mz, heuristic=no_heuristic), "~/Downloads/astar_no_heuristic.mp4", fps = 12, loop = 0)

Random.seed!(24)
mz = Maze(25, 25)
mp4(astar_movie(mz, heuristic=manhattan), "~/Downloads/astar_big_manhattan.mp4", fps = 25, loop = 0)
mp4(astar_movie(mz, heuristic=eucledian), "~/Downloads/astar_big_euclidean.mp4", fps = 25, loop = 0)
mp4(astar_movie(mz, heuristic=no_heuristic), "~/Downloads/astar_big_no_heuristic.mp4", fps = 25, loop = 0)


