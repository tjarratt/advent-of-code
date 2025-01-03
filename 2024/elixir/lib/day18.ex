defmodule Day18 do
  use AocTemplate

  @effectively_infinity 1_000_000

  @min_height 0
  @min_width 0
  @max_height 70
  @max_width 70

  @goal {70, 70}

  def part_one() do
    "input"
    |> read_file!()
    |> obstacles(max: 1024)
    |> build_map()
    |> shortest_path({0, 0})
    |> length()
    # first step doesn't count
    |> Kernel.-(1)
  end

  def part_two() do
    # magic number determined by doing binary search by hand
    # be lazy, be smart, be caveman
    obstacles =
      "input"
      |> read_file!()
      |> obstacles(max: 2912)

    obstacles
    |> build_map()
    |> flood()
    |> can_reach_origin?

    obstacles |> List.last() |> then(fn {y, x} -> "#{x},#{y}" end)

    # optimisation strategies that might be worth trying
    # we can walk backwards from the end of the input
    # we can walk forwards from 1024
    # we can use binary search of the space 1024..sizeof(input)
  end

  # # # part 2

  defp flood(obstacles) do
    visited = MapSet.new()
    visit_next = MapSet.new() |> MapSet.put(@goal)

    flood_fill(obstacles, visited, visit_next)
  end

  defp flood_fill(obstacles, visited, visit_next) do
    if MapSet.size(visit_next) == 0 do
      visited
    else
      next_squares =
        visit_next
        |> Enum.flat_map(fn location -> next_moves(location, visited, obstacles) end)
        |> MapSet.new()

      visited = MapSet.union(visited, next_squares)

      flood_fill(obstacles, visited, next_squares)
    end
  end

  defp can_reach_origin?(squares_visited) do
    MapSet.member?(squares_visited, {0, 0})
  end

  # # # part 1

  defp shortest_path(obstacles, starting_position) do
    visited = MapSet.new()
    came_from = Map.new()
    gScore = Map.new() |> Map.put(starting_position, 0)
    fScore = Map.new() |> Map.put(starting_position, 1)
    open_set = [starting_position]

    a_star(obstacles, visited, came_from, gScore, fScore, open_set)
  end

  # # # A*

  defp a_star(obstacles, visited, came_from, gScore, fScore, open_set) do
    current_position = Enum.min(open_set, fn a, b -> Map.get(fScore, a) <= Map.get(fScore, b) end)

    if at_destination?(current_position) do
      [current_position | reconstruct_path(came_from, current_position)]
    else
      updates =
        current_position
        |> next_moves(visited, obstacles)
        |> Enum.map(fn neighbor ->
          tentative_gscore = 1 + Map.get(gScore, current_position, @effectively_infinity)

          if tentative_gscore < Map.get(gScore, neighbor, @effectively_infinity) do
            [neighbor: neighbor, gScore: tentative_gscore, fScore: tentative_gscore]
          else
            nil
          end
        end)
        |> Enum.filter(&(!!&1))

      open_set_prime = updates |> Enum.map(&Keyword.get(&1, :neighbor))

      came_from_prime =
        Enum.reduce(open_set_prime, came_from, fn neighbor, acc ->
          Map.put(acc, neighbor, current_position)
        end)

      gScore_prime =
        updates
        |> Enum.map(fn update ->
          {Keyword.get(update, :neighbor), Keyword.get(update, :gScore)}
        end)
        |> Enum.reduce(fScore, fn {neighbor, score}, acc ->
          Map.put(acc, neighbor, score)
        end)

      fScore_prime =
        updates
        |> Enum.map(fn update ->
          {Keyword.get(update, :neighbor), Keyword.get(update, :fScore)}
        end)
        |> Enum.reduce(fScore, fn {neighbor, score}, acc ->
          Map.put(acc, neighbor, score)
        end)

      next_open_set = open_set ++ open_set_prime

      a_star(
        obstacles,
        MapSet.put(visited, current_position),
        came_from_prime,
        gScore_prime,
        fScore_prime,
        next_open_set -- [current_position]
      )
    end
  end

  defp next_moves({y, x}, visited, obstacles) do
    [
      {y - 1, x},
      {y + 1, x},
      {y, x - 1},
      {y, x + 1}
    ]
    |> Enum.reject(&MapSet.member?(visited, &1))
    |> Enum.reject(&MapSet.member?(obstacles, &1))
    |> Enum.reject(fn {y, x} ->
      y not in @min_height..@max_height or x not in @min_width..@max_width
    end)
  end

  defp at_destination?(location), do: location == @goal

  defp reconstruct_path(came_from, current) do
    case Map.get(came_from, current) do
      nil ->
        []

      previous ->
        [previous | reconstruct_path(came_from, previous)]
    end
  end

  # # # parsing

  defp obstacles(contents, max: how_many) do
    contents
    |> split_lines()
    |> Enum.map(fn line ->
      [x, y] = String.split(line, ",", trim: true)
      {String.to_integer(y), String.to_integer(x)}
    end)
    |> Enum.take(how_many)
  end

  defp build_map(obstacles), do: obstacles |> Enum.into(MapSet.new())
end
