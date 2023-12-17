defmodule Day14 do
  use AocTemplate

  # 104027 -- your answer is too low

  def part_one() do
    matrix =
      "input"
      |> read_file!()
      |> parse_matrix()
      |> roll_upwards()

    matrix
    |> Enum.map(fn row -> Enum.filter(row, &String.equivalent?(&1, "O")) end)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {row, index} -> length(row) * (index + 1) end)
    |> Enum.sum()
  end

  defp roll_upwards(matrix) do
    rolled_transposed =
      0..(length(hd(matrix)) - 1)
      |> Enum.map(fn x ->
        column = column_at(matrix, x)
        roll_column(column)
      end)

    0..(length(matrix) - 1)
    |> Enum.map(&column_at(rolled_transposed, &1))
  end

  defp roll_column(column, from_index \\ 0) do
    # find index of next rock to roll upwards
    index_tuple =
      column
      |> Enum.with_index()
      |> Enum.find(fn {char, i} -> char == "O" and i > from_index end)

    if index_tuple == nil do
      # already rolled as much as we can
      column
    else
      index = elem(index_tuple, 1)

      # find last index of "#" or "O" before index
      insert_index = find_previous_rock(column, before: index)

      # place it
      updated = column |> List.delete_at(index) |> List.insert_at(insert_index, "O")

      # recurse with from_index = index
      roll_column(updated, index)
    end
  end

  defp find_previous_rock(_column, before: 0), do: 0

  defp find_previous_rock(column, before: index) do
    0..(index - 1)
    |> Enum.map(fn idx -> {idx, Enum.at(column, idx)} end)
    |> Enum.reverse()
    |> Enum.find(fn {_idx, space} -> space == "#" or space == "O" end)
    |> maybe_index_or_zero()
  end

  defp maybe_index_or_zero(nil), do: 0
  defp maybe_index_or_zero({index, _space}), do: index + 1

  defp column_at(matrix, index) do
    Enum.map(matrix, fn row -> Enum.at(row, index) end)
  end

  defp parse_matrix(file) do
    file
    |> split_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
  end
end
