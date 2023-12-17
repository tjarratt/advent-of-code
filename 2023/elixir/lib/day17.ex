defmodule Day17 do
  use AocTemplate

  @effectively_infinity 1_000_000

  def part_one() do
    start = {0, 0, :at_rest}
    came_from = Map.new()
    gScore = Map.new() |> Map.put(start, 0)
    fScore = Map.new() |> Map.put(start, 1)

    matrix =
      "input"
      |> read_file!()
      |> parse_matrix()

    matrix
    |> a_star(Map.new(), came_from, gScore, fScore, [start])
    |> Enum.reverse()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [from, to] -> heat_lost_between(matrix, from, to) end)
    |> Enum.sum()
  end

  def part_two() do
    start = {0, 0, :at_rest}
    came_from = Map.new()
    gScore = Map.new() |> Map.put(start, 0)
    fScore = Map.new() |> Map.put(start, 1)

    matrix =
      "input"
      |> read_file!()
      |> parse_matrix()

    matrix
    |> a_star(Map.new(), came_from, gScore, fScore, [start], ultra: true)
    |> Enum.reverse()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [from, to] -> heat_lost_between(matrix, from, to) end)
    |> Enum.sum()
  end

  defp a_star(matrix, visited, came_from, gScore, fScore, open_set, opts \\ []) do
    current_position =
      Enum.min(open_set, fn a, b ->
        Map.get(fScore, a) <= Map.get(fScore, b)
      end)

    if arrived?(matrix, current_position) do
      [current_position] ++ reconstruct_path(came_from, current_position)
    else
      neighbors = movement_options(matrix, visited, current_position, opts)

      updates =
        Enum.map(neighbors, fn neighbor ->
          heat_lost = heat_lost_between(matrix, current_position, neighbor)
          tentative_gscore = Map.get(gScore, current_position, @effectively_infinity) + heat_lost

          if tentative_gscore < Map.get(gScore, neighbor, @effectively_infinity) do
            [neighbor: neighbor, gScore: tentative_gscore, fScore: tentative_gscore]
          else
            nil
          end
        end)
        |> Enum.reject(fn n -> n == nil end)

      open_set_prime = updates |> Enum.map(&Keyword.get(&1, :neighbor))

      came_from_prime =
        open_set_prime
        |> Enum.reduce(came_from, fn neighbor, acc ->
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
        |> Enum.reduce(fScore, fn {neighbor, score}, acc ->
          Map.put(acc, neighbor, score)
        end)

      next_open_set = open_set ++ open_set_prime

      a_star(
        matrix,
        Map.put(visited, current_position, true),
        came_from_prime,
        gScore_prime,
        fScore_prime,
        next_open_set -- [current_position],
        opts
      )
    end
  end

  defp heat_lost_between(matrix, {y, x, _}, {y, xprime, :right}) do
    1..(xprime - x)
    |> Enum.map(fn diff -> heat_lost_at(matrix, {y, x + diff, :right}) end)
    |> Enum.sum()
  end

  defp heat_lost_between(matrix, {y, x, _}, {y, xprime, :left}) do
    1..(x - xprime)
    |> Enum.map(fn diff -> heat_lost_at(matrix, {y, x - diff, :left}) end)
    |> Enum.sum()
  end

  defp heat_lost_between(matrix, {y, x, _}, {yprime, x, :up}) do
    1..(y - yprime)
    |> Enum.map(fn diff -> heat_lost_at(matrix, {y - diff, x, :up}) end)
    |> Enum.sum()
  end

  defp heat_lost_between(matrix, {y, x, _}, {yprime, x, :down}) do
    1..(yprime - y)
    |> Enum.map(fn diff -> heat_lost_at(matrix, {y + diff, x, :down}) end)
    |> Enum.sum()
  end

  defp heat_lost_at(matrix, {y, x, _direction}) do
    matrix |> Enum.at(y) |> Enum.at(x)
  end

  defp movement_options(matrix, previously_visited, {y, x, previous_direction}, ultra: true) do
    directions =
      for i <- 4..10 do
        [
          {y, x + i, :right},
          {y, x - i, :left},
          {y + i, x, :down},
          {y - i, x, :up}
        ]
      end

    directions
    |> List.flatten()
    |> Enum.reject(&outside_city_limits?(matrix, &1))
    |> Enum.reject(fn {_y, _x, dir} -> dir == previous_direction end)
    |> Enum.reject(fn choice -> Map.has_key?(previously_visited, choice) end)
    |> Enum.reject(&opposite_direction?(&1, previous_direction))
  end

  defp movement_options(matrix, previously_visited, {y, x, previous_direction}, []) do
    directions =
      for i <- 1..3 do
        [
          {y, x + i, :right},
          {y, x - i, :left},
          {y + i, x, :down},
          {y - i, x, :up}
        ]
      end

    directions
    |> List.flatten()
    |> Enum.reject(&outside_city_limits?(matrix, &1))
    |> Enum.reject(fn {_y, _x, dir} -> dir == previous_direction end)
    |> Enum.reject(fn choice -> Map.has_key?(previously_visited, choice) end)
    |> Enum.reject(&opposite_direction?(&1, previous_direction))
  end

  defp opposite_direction?({_, _, :up}, :down), do: true
  defp opposite_direction?({_, _, :down}, :up), do: true
  defp opposite_direction?({_, _, :left}, :right), do: true
  defp opposite_direction?({_, _, :right}, :left), do: true
  defp opposite_direction?(_, _), do: false

  defp outside_city_limits?(matrix, {y, x, _direction}) do
    height = length(matrix)
    width = length(hd(matrix))

    y < 0 or x < 0 or
      y >= height or x >= width
  end

  defp reconstruct_path(_came_from, {0, 0, :at_rest}) do
    []
  end

  defp reconstruct_path(came_from, current) do
    previous = Map.get(came_from, current)

    [previous] ++ reconstruct_path(came_from, previous)
  end

  defp arrived?(matrix, {y, x, _direction}) do
    destination = {length(matrix) - 1, length(hd(matrix)) - 1}

    destination == {y, x}
  end

  defp parse_matrix(file) do
    file
    |> split_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(fn line -> Enum.map(line, fn block -> String.to_integer(block) end) end)
  end
end
