defmodule Day10 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse_matrix()
    |> List.flatten()
    |> (fn matrix ->
          start = Enum.find(matrix, fn {_, _, char} -> char == "S" end)

          matrix
          |> find_neighbors(start)
          |> Enum.filter(&connecting?(&1, start))
          |> hd()
          |> (fn node ->
                {:closed_loop, loop} = forms_closed_loop?(matrix, node, [start], to: start)
                loop
              end).()
        end).()
    |> (fn loop -> (length(loop) / 2) |> trunc() end).()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> parse_matrix()
    |> (fn matrix -> {matrix, List.flatten(matrix)} end).()
    |> (fn {rows, matrix} ->
          start = Enum.find(matrix, fn {_, _, char} -> char == "S" end)

          loop =
            matrix
            |> find_neighbors(start)
            |> Enum.filter(&connecting?(&1, start))
            |> hd()
            |> (fn node ->
                  {:closed_loop, loop} = forms_closed_loop?(matrix, node, [start], to: start)
                  loop
                end).()

          {loop, rows}
        end).()
    |> (fn {loop, rows} -> Enum.map(rows, &raycast(&1, loop, 0)) end).()
    |> Enum.sum()
  end

  defp raycast([], _, _), do: 0

  defp raycast(row, loop, count) do
    [{_, _, char} = point | rest] = row

    left_corners = ~w( S F L )
    right_corners = ~w( J 7 )

    cond do
      char in left_corners and point in loop ->
        {remaining, diff} = until_out_of_loop(char, rest, loop)
        raycast(remaining, loop, count + diff)

      char in right_corners and point in loop ->
        {remaining, diff} = until_out_of_loop(char, rest, loop)
        raycast(remaining, loop, count + diff)

      char == "|" and point in loop ->
        raycast(rest, loop, count + 1)

      rem(count, 2) == 1 ->
        1 + raycast(rest, loop, count)

      true ->
        raycast(rest, loop, count)
    end
  end

  # Continue to read from the row until we are out of the pipe
  # Also, keep track of whether this enters or exits the polygon during this time.
  defp until_out_of_loop(corner, row, loop) do
    [{_, _, char} = point | rest] = row

    cond do
      char == "-" and point in loop ->
        until_out_of_loop(corner, rest, loop)

      # S is a bit of a wildcard, and it's unclear whether we enter or exit
      # This is correct for some inputs, and incorrect for others, sadly
      corner == "S" and point in loop and char == "J" ->
        {rest, 1}

      corner == "S" and point in loop and char == "7" ->
        {rest, 0}

      corner == "F" and point in loop and char == "J" ->
        {rest, 1}

      corner == "F" and point in loop and char == "7" ->
        {rest, 0}

      corner == "F" and point in loop and char == "S" ->
        {rest, 0}

      corner == "L" and point in loop and char == "J" ->
        {rest, 0}

      corner == "L" and point in loop and char == "7" ->
        {rest, 1}

      corner == "L" and point in loop and char == "S" ->
        {rest, 0}
    end
  end

  defp forms_closed_loop?(matrix, current, previous_pipes, to: starting_point) do
    if current == starting_point do
      {:closed_loop, previous_pipes}
    else
      previous = List.last(previous_pipes)
      neighbors = find_neighbors(matrix, current)
      next_pipe = find_next_pipe(neighbors -- [previous], current)

      case next_pipe do
        nil ->
          {:nope}

        _ ->
          forms_closed_loop?(matrix, next_pipe, previous_pipes ++ [current], to: starting_point)
      end
    end
  end

  defp connecting?({_y, x1, "|"}, {_w, x2, "|"}) when x1 == x2, do: true
  defp connecting?({y1, x1, "|"}, {y2, x2, "L"}) when x1 == x2 and y2 == y1 + 1, do: true
  defp connecting?({y1, x1, "|"}, {y2, x2, "J"}) when x1 == x2 and y2 == y1 + 1, do: true
  defp connecting?({y1, x1, "|"}, {y2, x2, "7"}) when x1 == x2 and y2 == y1 - 1, do: true
  defp connecting?({y1, x1, "|"}, {y2, x2, "F"}) when x1 == x2 and y2 == y1 - 1, do: true
  defp connecting?({_y, x1, "|"}, {_w, x2, "S"}) when x1 == x2, do: true

  defp connecting?({y1, _x, "-"}, {y2, _w, "-"}) when y1 == y2, do: true
  defp connecting?({y1, x1, "-"}, {y2, x2, "L"}) when y1 == y2 and x2 == x1 - 1, do: true
  defp connecting?({y1, x1, "-"}, {y2, x2, "F"}) when y1 == y2 and x2 == x1 - 1, do: true
  defp connecting?({y1, x1, "-"}, {y2, x2, "7"}) when y1 == y2 and x2 == x1 + 1, do: true
  defp connecting?({y1, x1, "-"}, {y2, x2, "J"}) when y1 == y2 and x2 == x1 + 1, do: true
  defp connecting?({y1, _x, "-"}, {y2, _w, "S"}) when y1 == y2, do: true

  defp connecting?({y1, x1, "L"}, {y2, x2, "|"}) when y2 == y1 - 1 and x2 == x1, do: true
  defp connecting?({y1, x1, "L"}, {y2, x2, "F"}) when y2 == y1 - 1 and x2 == x1, do: true
  defp connecting?({y1, x1, "L"}, {y2, x2, "-"}) when y2 == y1 and x2 == x1 + 1, do: true
  defp connecting?({y1, x1, "L"}, {y2, x2, "J"}) when y2 == y1 and x2 == x1 + 1, do: true

  defp connecting?({y1, x1, "L"}, {y2, x2, "7"})
       when (y2 == y1 and x2 == x1 + 1) or (y2 == y1 - 1 and x2 == x1),
       do: true

  defp connecting?({y1, x1, "L"}, {y2, x2, "S"})
       when (y2 == y1 and x2 == x1 + 1) or (y2 == y1 - 1 and x2 == x1),
       do: true

  defp connecting?({y1, x1, "J"}, {y2, x2, "|"}) when y2 == y1 - 1 and x1 == x2, do: true
  defp connecting?({y1, x1, "J"}, {y2, x2, "7"}) when y2 == y1 - 1 and x2 == x1, do: true
  defp connecting?({y1, x1, "J"}, {y2, x2, "-"}) when y2 == y1 and x2 == x1 - 1, do: true
  defp connecting?({y1, x1, "J"}, {y2, x2, "L"}) when y2 == y1 and x2 == x1 - 1, do: true

  defp connecting?({y1, x1, "J"}, {y2, x2, "F"})
       when (y2 == y1 and x2 == x1 - 1) or (y2 == y1 - 1 and x2 == x1),
       do: true

  defp connecting?({y1, x1, "J"}, {y2, x2, "S"})
       when (y2 == y1 and x2 == x1 - 1) or (y2 == y1 - 1 and x2 == x1),
       do: true

  defp connecting?({y1, x1, "7"}, {y2, x2, "|"}) when y2 == y1 + 1 and x2 == x1, do: true
  defp connecting?({y1, x1, "7"}, {y2, x2, "J"}) when y2 == y1 + 1 and x2 == x1, do: true
  defp connecting?({y1, x1, "7"}, {y2, x2, "-"}) when y2 == y1 and x2 == x1 - 1, do: true
  defp connecting?({y1, x1, "7"}, {y2, x2, "F"}) when y2 == y1 and x2 == x1 - 1, do: true

  defp connecting?({y1, x1, "7"}, {y2, x2, "L"})
       when (y2 == y1 and x2 == x1 - 1) or (y2 == y1 + 1 and x2 == x1),
       do: true

  defp connecting?({y1, x1, "7"}, {y2, x2, "S"})
       when (y2 == y1 and x2 == x1 - 1) or (y2 == y1 + 1 and x2 == x1),
       do: true

  defp connecting?({y1, x1, "F"}, {y2, x2, "|"}) when y2 == y1 + 1 and x2 == x1, do: true
  defp connecting?({y1, x1, "F"}, {y2, x2, "L"}) when y2 == y1 + 1 and x2 == x1, do: true
  defp connecting?({y1, x1, "F"}, {y2, x2, "-"}) when y2 == y1 and x2 == x1 + 1, do: true
  defp connecting?({y1, x1, "F"}, {y2, x2, "7"}) when y2 == y1 and x2 == x1 + 1, do: true

  defp connecting?({y1, x1, "F"}, {y2, x2, "J"})
       when (y2 == y1 + 1 and x2 == x1) or (y2 == y1 and x2 == x1 + 1),
       do: true

  defp connecting?({y1, x1, "F"}, {y2, x2, "S"})
       when (y2 == y1 and x2 == x1 + 1) or (y2 == y1 + 1 and x2 == x1),
       do: true

  defp connecting?({_, _, "S"} = start, other), do: connecting?(other, start)
  defp connecting?(_, _), do: false

  def find_next_pipe(options, current) do
    case Enum.filter(options, fn node -> connecting?(node, current) end) do
      [] ->
        nil

      [pipe] ->
        pipe

      _wtf ->
        raise "Where the heck did you get that banana ?"
    end
  end

  defp find_neighbors(matrix, current) do
    current
    |> direct_neighbors_of()
    |> Enum.map(fn {y, x} -> element_at(matrix, y, x) end)
  end

  defp parse_matrix(file) do
    file
    |> split_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.with_index(&with_tuple/2)
    |> Enum.map(fn {y_index, row} ->
      Enum.with_index(row, fn ele, x_index -> {y_index, x_index, ele} end)
    end)
  end

  defp with_tuple(element, index), do: {index, element}

  defp element_at(matrix, y, x) do
    Enum.find(matrix, fn {y_idx, x_idx, _ele} -> y_idx == y && x_idx == x end)
  end

  defp direct_neighbors_of({y, x, _symbol}) do
    [
      # top row
      {y - 1, x},
      # middle row
      {y, x - 1},
      {y, x + 1},
      # bottom row
      {y + 1, x}
    ]
  end
end
