defmodule Day06 do
  use AocTemplate

  alias Day06.Grid
  alias Day06.Guard

  defmodule Guard do
    defstruct [:x, :y, :direction]
  end

  def part_one() do
    locations_visited =
      "input"
      |> read_file!()
      |> Grid.parse()
      |> count_guards_steps(MapSet.new())

    # include guard's initial position
    MapSet.size(locations_visited) + 1
  end

  defp leaving_grid?(_max_y, _max_x, guard)
       when guard.x == 0 and guard.direction == "<",
       do: true

  defp leaving_grid?(_max_y, _max_x, guard)
       when guard.y == 0 and guard.direction == "^",
       do: true

  defp leaving_grid?(max_y, _max_x, guard)
       when guard.y == max_y and guard.direction == "v",
       do: true

  defp leaving_grid?(_max_y, max_x, guard)
       when guard.x == max_x and guard.direction == ">",
       do: true

  defp leaving_grid?(_, _, _), do: false

  defp count_guards_steps({grid, max_y, max_x, guard}, locations_visited) do
    {visited, new_x, new_y} = obstacle_for(grid, guard)

    locations_visited = locations_visited |> MapSet.union(MapSet.new(visited))

    guard = %{guard | x: new_x, y: new_y}

    if leaving_grid?(max_y, max_x, guard) do
      locations_visited
    else
      new_direction =
        case guard.direction do
          "^" -> ">"
          ">" -> "v"
          "v" -> "<"
          "<" -> "^"
        end

      new_guard = %{guard | direction: new_direction}
      count_guards_steps({grid, max_x, max_y, new_guard}, locations_visited)
    end
  end

  defp obstacle_for(grid, guard) do
    line =
      case guard.direction do
        "^" ->
          grid
          |> List.flatten()
          |> Enum.filter(&(&1.x == guard.x and &1.y < guard.y))
          |> Enum.sort(fn a, b -> a.y > b.y end)

        ">" ->
          grid
          |> List.flatten()
          |> Enum.filter(&(&1.y == guard.y and &1.x > guard.x))
          |> Enum.sort(fn a, b -> a.x < b.x end)

        "v" ->
          grid
          |> List.flatten()
          |> Enum.filter(&(&1.x == guard.x and &1.y > guard.y))
          |> Enum.sort(fn a, b -> a.y < b.y end)

        "<" ->
          grid
          |> List.flatten()
          |> Enum.filter(&(&1.y == guard.y and &1.x < guard.x))
          |> Enum.sort(fn a, b -> a.x > b.x end)
      end

    index = index_stops_at(line)
    visited = Enum.slice(line, 0..index)
    new_location = Enum.at(line, index)

    {visited, new_location.x, new_location.y}
  end

  # find the index we stop at
  defp index_stops_at(points) do
    # if there is an obstacle, it's the one previous to it
    if obstacle = Enum.find(points, &(&1.visitable? == false)) do
      Enum.find_index(points, &(&1 == obstacle)) - 1
    else
      # if there was no obstacle, stop before leaving the grid
      length(points) - 1
    end
  end

  defmodule Location do
    defstruct [:visitable?, :x, :y, :contains, :character]
  end

  defmodule Grid do
    def parse(file) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.with_index()
      |> Enum.map(fn {line, y_index} -> {Enum.with_index(line), y_index} end)
      |> Enum.map(fn {line, y_index} ->
        {Enum.map(line, fn {location, x_index} -> to_node(location, x_index, y_index) end),
         y_index}
      end)
      |> then(fn with_indices ->
        grid = drop_indices(with_indices)

        {grid, length(grid) - 1, length(hd(grid)) - 1, find_guard(grid)}
      end)
    end

    defp find_guard(grid) do
      grid
      |> List.flatten()
      |> Enum.find(&(&1.contains == :guard))
      #                                                                       ^ at least for my inputs, the guard is always going north to start
      |> then(fn location -> %Guard{x: location.x, y: location.y, direction: "^"} end)
    end

    defp to_node(".", x, y),
      do: %Location{character: ".", x: x, y: y, visitable?: true, contains: :nothing}

    defp to_node(str, x, y) when str in ~w[^ v < >],
      do: %Location{character: "s", x: x, y: y, visitable?: true, contains: :guard}

    defp to_node("#", x, y),
      do: %Location{character: "#", x: x, y: y, visitable?: false, contains: :obstacle}

    defp drop_indices(grid) do
      grid |> Enum.map(fn {line, _Y} -> line end)
    end
  end
end
