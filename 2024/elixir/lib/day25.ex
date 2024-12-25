defmodule Day25 do
  use AocTemplate

  @max_height 6

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> all_combinations()
    |> Enum.filter(&valid?/1)
    |> length()
  end

  defp all_combinations(%{keys: keys, locks: locks}) do
    for key <- keys, lock <- locks, do: {lock, key}
  end

  defp valid?({lock, key}) do
    key_heights = heights(key)
    lock_heights = heights(lock)

    Enum.zip(key_heights, lock_heights)
    |> Enum.all?(fn heights ->
      Tuple.sum(heights) < @max_height
    end)
  end

  defp heights(key_or_lock) do
    Enum.map(key_or_lock, fn column ->
      height = column |> Enum.map(&if(&1 == "#", do: 1, else: 0)) |> Enum.sum()

      height - 1
    end)
  end

  defp parse(contents) do
    contents
    |> split_lines(on: "\n\n")
    |> Enum.map(&parse_one/1)
    |> Enum.map(fn {as_rows, as_columns} ->
      first_row = hd(as_rows)
      category = if Enum.all?(first_row, &(&1 == "#")), do: :locks, else: :keys

      {category, as_columns}
    end)
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.update(acc, key, [value], fn values -> [value | values] end)
    end)
  end

  defp parse_one(string) do
    as_rows = string |> split_lines() |> Enum.map(&String.split(&1, "", trim: true))
    as_columns = as_rows |> transpose()

    {as_rows, as_columns}
  end

  defp transpose(rows) do
    Enum.zip_with(rows, &Function.identity/1)
  end
end
