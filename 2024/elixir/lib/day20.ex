defmodule Day20 do
  use AocTemplate

  @max_width 141
  @max_height 141

  @effectively_infinity 1_000_000

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> find_path()
    |> identify_shortcuts()
    |> Enum.reject(&(&1 == 0))
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.filter(fn {picoseconds_saved, _how_many} -> picoseconds_saved >= 100 end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  defp find_path({grid, start, finish}) do
    visited = MapSet.new()
    came_from = Map.new()
    gScore = Map.new() |> Map.put(start, 0)
    fScore = Map.new() |> Map.put(start, 1)
    open_set = [start]

    best_path =
      a_star(grid, finish, visited, came_from, gScore, fScore, open_set)
      |> Enum.reverse()
      |> Enum.with_index()

    {grid, best_path}
  end

  defp reconstruct_path(came_from, position) do
    case Map.get(came_from, position) do
      nil -> []
      previous -> [previous | reconstruct_path(came_from, previous)]
    end
  end

  defp next_moves({y, x}, visited, grid) do
    [
      {y - 1, x},
      {y + 1, x},
      {y, x - 1},
      {y, x + 1}
    ]
    |> Enum.reject(fn coords -> MapSet.member?(visited, coords) end)
    |> Enum.reject(fn coords -> Map.get(grid, coords) == "#" end)
    |> Enum.reject(fn {y, x} -> x not in 0..@max_width or y not in 0..@max_height end)
  end

  defp a_star(grid, destination, visited, came_from, gScore, fScore, open_set) do
    current_position = Enum.min(open_set, fn a, b -> Map.get(fScore, a) <= Map.get(fScore, b) end)

    if current_position == destination do
      [current_position | reconstruct_path(came_from, current_position)]
    else
      updates =
        current_position
        |> next_moves(visited, grid)
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
        |> Enum.reduce(gScore, fn {neighbor, score}, acc -> Map.put(acc, neighbor, score) end)

      fScore_prime =
        updates
        |> Enum.map(fn update ->
          {Keyword.get(update, :neighbor), Keyword.get(update, :fScore)}
        end)
        |> Enum.reduce(fScore, fn {neighbor, score}, acc -> Map.put(acc, neighbor, score) end)

      next_open_set = (open_set -- [current_position]) ++ open_set_prime

      a_star(
        grid,
        destination,
        MapSet.put(visited, current_position),
        came_from_prime,
        gScore_prime,
        fScore_prime,
        next_open_set
      )
    end
  end

  defp identify_shortcuts({_grid, []}), do: []

  defp identify_shortcuts({grid, [position | remaining]}) do
    shortcuts =
      shortcut_choices(position)
      |> Enum.filter(&valid_shortcut?(&1, grid, remaining))
      |> Enum.map(&gains(&1, position, remaining))

    shortcuts ++ identify_shortcuts({grid, remaining})
  end

  defp gains([_skip_coords, end_coords], {_start_coords, start_index}, path) do
    {^end_coords, end_index} = Enum.find(path, fn {point, _index} -> point == end_coords end)

    # take into account the fact that it cheats and jumps to the location
    end_index - start_index - 2
  end

  defp shortcut_choices({{y, x}, _index}) do
    [
      [{y - 1, x}, {y - 2, x}],
      [{y + 1, x}, {y + 2, x}],
      [{y, x - 1}, {y, x - 2}],
      [{y, x + 1}, {y, x + 2}]
    ]
  end

  defp valid_shortcut?([skip, arrive], grid, path_with_index) do
    path = Enum.map(path_with_index, &elem(&1, 0))

    Map.get(grid, skip) == "#" and skip in path
    (Map.get(grid, arrive) == "." or Map.get(grid, arrive) == "E") and arrive in path
  end

  # # # parsing

  defp parse(contents) do
    grid = contents |> parse_to_grid()
    as_list = Map.to_list(grid)

    start = as_list |> Enum.find(fn {_coords, node} -> node == "S" end) |> elem(0)
    finish = as_list |> Enum.find(fn {_coords, node} -> node == "E" end) |> elem(0)

    {grid, start, finish}
  end
end
