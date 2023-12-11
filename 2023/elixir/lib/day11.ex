defmodule Day11 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse_matrix()
    |> expand_empty_space_between_galaxies()
    |> Enum.with_index(&with_tuple/2)
    |> Enum.map(fn {y_index, row} ->
      Enum.with_index(row, fn ele, x_index -> {y_index, x_index, ele} end)
    end)
    |> Enum.map(fn row -> Enum.filter(row, fn {_, _, char} -> char == "#" end) end)
    |> List.flatten()
    |> (fn galaxies ->
          for a <- galaxies, b <- galaxies, a != b, do: [a, b]
        end).()
    |> Enum.map(fn [a, b] -> manhattan_distance(a, b) end)
    |> Enum.sum()
    # the pairs are double counted, so divide by two
    |> Integer.floor_div(2)
  end

  defp manhattan_distance({y1, x1, _}, {y2, x2, _}) do
    abs(y1 - y2) + abs(x1 - x2)
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
end
