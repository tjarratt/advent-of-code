defmodule Day11 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse_matrix()
    |> expand_empty_space_between_galaxies()
    |> map_to_tuple()
    |> Enum.map(fn row -> Enum.filter(row, fn {_, _, char} -> char == "#" end) end)
    |> List.flatten()
    |> (fn galaxies -> for a <- galaxies, b <- galaxies, do: [a, b] end).()
    |> Enum.map(&manhattan_distance/1)
    |> Enum.sum()
    # the pairs are double counted, so divide by two
    |> Integer.floor_div(2)
  end

  def part_two() do
    "input"
    |> read_file!()
    |> parse_matrix()
    |> Enum.with_index(&with_tuple/2)
    |> Enum.map(fn {y_index, row} ->
      Enum.with_index(row, fn ele, x_index -> {y_index, x_index, ele} end)
    end)
    |> expand_part2()
    |> (fn {matrix, y_indices, x_indices} ->
          galaxies =
            matrix
            |> Enum.map(fn row -> Enum.filter(row, fn {_, _, char} -> char == "#" end) end)
            |> List.flatten()

          pairs = for a <- galaxies, b <- galaxies, do: [a, b]

          Enum.map(pairs, fn [a, b] ->
            manhattan_distance_part2(a, b, y_indices, x_indices, factor: 1_000_000)
          end)
        end).()
    |> Enum.sum()
    |> Integer.floor_div(2)
  end

  defp manhattan_distance_part2(
         {y1, x1, _} = point_a,
         {y2, x2, _} = point_b,
         y_indices,
         x_indices,
         factor: factor
       ) do
    y_expansion =
      y_indices
      |> Enum.filter(fn y -> (y1 < y and y < y2) or (y1 > y and y > y2) end)
      |> length()
      # factor -1 because these would be double counted in the manhattan distance calculation
      |> (fn length -> length * (factor - 1) end).()

    x_expansion =
      x_indices
      |> Enum.filter(fn x -> (x1 < x and x < x2) or (x1 > x and x > x2) end)
      |> length()
      # factor -1 because these would be double counted in the manhattan distance calculation
      |> (fn length -> length * (factor - 1) end).()

    manhattan_distance([point_a, point_b]) + y_expansion + x_expansion
  end

  defp manhattan_distance([{y1, x1, _}, {y2, x2, _}]) do
    abs(y1 - y2) + abs(x1 - x2)
  end

  defp expand_part2(matrix) do
    height = length(matrix)
    width = length(hd(matrix))

    y_indices =
      0..(height - 1)
      |> Enum.filter(fn y_index ->
        row = row_at(matrix, y_index) |> Enum.map(&elem(&1, 2))

        "#" not in row
      end)

    x_indices =
      0..(width - 1)
      |> Enum.filter(fn x_index ->
        column = column_at(matrix, x_index) |> Enum.map(&elem(&1, 2))

        "#" not in column
      end)

    {matrix, y_indices, x_indices}
  end

  # pragma mark - expanding universe

  defp expand_empty_space_between_galaxies(matrix) do
    height = length(matrix)
    width = length(hd(matrix))

    y_indices =
      0..(height - 1)
      |> Enum.filter(fn y_index ->
        row = row_at(matrix, y_index)

        "#" not in row
      end)
      |> Enum.reverse()

    taller_matrix = grow_taller(matrix, y_indices)

    x_indices =
      0..(width - 1)
      |> Enum.filter(fn x_index ->
        column = column_at(taller_matrix, x_index)

        "#" not in column
      end)
      |> Enum.reverse()

    grow_wider(taller_matrix, x_indices)
  end

  defp grow_taller(matrix, []), do: matrix

  defp grow_taller(matrix, [y_index | rest]) do
    matrix
    |> List.insert_at(y_index, Enum.at(matrix, y_index))
    |> grow_taller(rest)
  end

  defp grow_wider(matrix, []), do: matrix

  defp grow_wider(matrix, [x_index | rest]) do
    column = column_at(matrix, x_index)

    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, y} -> List.insert_at(row, x_index, Enum.at(column, y)) end)
    |> grow_wider(rest)
  end

  # pragma mark - matrix helpers

  defp row_at(matrix, index) do
    Enum.at(matrix, index)
  end

  defp column_at(matrix, index) do
    Enum.map(matrix, fn row -> Enum.at(row, index) end)
  end

  defp parse_matrix(file) do
    file
    |> split_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp with_tuple(element, index), do: {index, element}

  defp map_to_tuple(matrix) do
    matrix
    |> Enum.with_index(&with_tuple/2)
    |> Enum.map(fn {y_index, row} ->
      Enum.with_index(row, fn ele, x_index -> {y_index, x_index, ele} end)
    end)
  end
end
