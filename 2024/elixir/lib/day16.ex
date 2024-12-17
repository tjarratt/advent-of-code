defmodule Day16 do
  use AocTemplate

  @effectively_infinity 1_000_000

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> best_path()
    |> score()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> parse()
    |> best_paths()
    |> Enum.map(fn path -> path |> Enum.map(&elem(&1, 0)) end)
    |> List.flatten()
    |> Enum.uniq()
    |> length()
  end

  defp score(moves) do
    moves
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [{_c1, d1}, {_c2, d2}], acc ->
      if d1 != d2 do
        acc + 1000
      else
        acc + 1
      end
    end)
  end

  defp best_path({map, current_location, finish}) do
    visited = Map.new()
    came_from = Map.new()
    gScore = Map.new() |> Map.put(current_location, 0)
    fScore = Map.new() |> Map.put(current_location, 1)

    a_star(map, finish, visited, came_from, gScore, fScore, [current_location])
  end

  # # # part 2

  defp best_paths({map, current_location, finish}) do
    visited = Map.new()
    came_from = Map.new()
    gScore = Map.new() |> Map.put(current_location, 0)
    fScore = Map.new() |> Map.put(current_location, 1)

    a_star_all_paths(
      map,
      finish,
      visited,
      came_from,
      gScore,
      fScore,
      [current_location],
      @effectively_infinity
    )
  end

  # # # A* algorithm

  defp a_star(map, destination, visited, came_from, gScore, fScore, open_set) do
    current_position = Enum.min(open_set, fn a, b -> Map.get(fScore, a) <= Map.get(fScore, b) end)

    if at_destination?(current_position, destination) do
      [current_position | reconstruct_path(came_from, current_position)]
    else
      updates =
        map
        |> next_moves(visited, current_position)
        |> Enum.map(fn {neighbor, cost} ->
          tentative_gscore = cost + Map.get(gScore, current_position, @effectively_infinity)

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
        map,
        destination,
        Map.put(visited, current_position, true),
        came_from_prime,
        gScore_prime,
        fScore_prime,
        next_open_set -- [current_position]
      )
    end
  end

  defp a_star_all_paths(
         map,
         destination,
         visited,
         came_from,
         gScore,
         fScore,
         open_set,
         winning_score
       ) do
    {current_position, current_score} =
      open_set
      |> Enum.map(&{&1, Map.get(fScore, &1)})
      |> Enum.sort(fn {_, a}, {_, b} -> a < b end)
      |> hd()

    cond do
      current_score > winning_score ->
        []

      at_destination?(current_position, destination) ->
        winner = [current_position | reconstruct_path(came_from, current_position, :part_two)]

        # continue to recurse all other paths
        new_open_set = (open_set -- [current_position]) |> Enum.uniq()

        [
          winner
          | a_star_all_paths(
              map,
              destination,
              visited,
              came_from,
              gScore,
              fScore,
              new_open_set,
              current_score
            )
        ]

      true ->
        updates =
          map
          |> next_moves(visited, current_position)
          |> Enum.map(fn {neighbor, cost} ->
            tentative_gscore = cost + Map.get(gScore, current_position, @effectively_infinity)

            if tentative_gscore <= Map.get(gScore, neighbor, @effectively_infinity) do
              [neighbor: neighbor, gScore: tentative_gscore, fScore: tentative_gscore]
            else
              nil
            end
          end)
          |> Enum.filter(&(!!&1))

        open_set_prime = updates |> Enum.map(&Keyword.get(&1, :neighbor))

        came_from_prime =
          Enum.reduce(open_set_prime, came_from, fn neighbor, acc ->
            Map.update(acc, neighbor, [current_position], fn existing ->
              [current_position | existing]
            end)
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

        next_open_set = (open_set ++ open_set_prime) |> Enum.uniq()

        a_star_all_paths(
          map,
          destination,
          Map.put(visited, current_position, true),
          came_from_prime,
          gScore_prime,
          fScore_prime,
          next_open_set -- [current_position],
          winning_score
        )
    end
  end

  defp at_destination?({coords, _facing}, destination), do: coords == destination

  defp reconstruct_path(came_from, current) do
    case Map.get(came_from, current) do
      nil ->
        []

      previous ->
        [previous | reconstruct_path(came_from, previous)]
    end
  end

  defp reconstruct_path(came_from, current, :part_two) do
    case Map.get(came_from, current) do
      nil ->
        []

      locations ->
        locations
    end
    |> Enum.uniq()
    |> Enum.map(fn loc ->
      [loc | reconstruct_path(came_from, loc, :part_two)]
    end)
    |> List.flatten()
  end

  defp next_moves(map, visited, {{y, x}, direction}) do
    [movement_option({y, x}, direction) | rotation_options({y, x}, direction)]
    |> Enum.reject(&Map.has_key?(visited, &1))
    |> Enum.reject(fn {{coords, _facing}, _cost} -> Map.fetch!(map, coords) == "#" end)
  end

  defp movement_option({y, x}, direction) do
    # movement only costs 1
    case direction do
      :north -> {{{y - 1, x}, direction}, 1}
      :south -> {{{y + 1, x}, direction}, 1}
      :west -> {{{y, x - 1}, direction}, 1}
      :east -> {{{y, x + 1}, direction}, 1}
    end
  end

  defp rotation_options(position, direction) do
    case direction do
      :north -> [:east, :west]
      :south -> [:east, :west]
      :west -> [:north, :south]
      :east -> [:north, :south]
    end
    |> Enum.map(&{position, &1})
    # rotating costs a lot
    |> Enum.map(&{&1, 1000})
  end

  # # # parsing

  defp parse(contents) do
    map = parse_to_grid(contents)

    start = map |> Map.to_list() |> Enum.find(fn {_key, value} -> value == "S" end) |> elem(0)
    finish = map |> Map.to_list() |> Enum.find(fn {_key, value} -> value == "E" end) |> elem(0)

    {map, {start, :east}, finish}
  end
end
