defmodule Day08 do
  use AocTemplate

  alias __MODULE__.Grid

  def part_one() do
    "input"
    |> read_file!()
    |> Grid.parse()
    |> find_antinodes()
    |> Enum.into(MapSet.new())
    |> MapSet.size()
  end

  defp antinodes_for(a, b) do
    dx = a.x - b.x
    dy = b.y - a.y

    [
      %{x: a.x + dx, y: a.y - dy},
      %{x: b.x - dx, y: b.y + dy}
    ]
  end

  defp find_antinodes({grid, max_y, max_x}) do
    grid
    |> extract_signals()
    |> Enum.map(&calculate_antinodes(&1, grid))
    |> List.flatten()
    |> Enum.reject(&exclude_outside(&1, max_y, max_x))
  end

  defp exclude_outside(antinode, max_y, max_x) do
    cond do
      antinode.x < 0 -> true
      antinode.x > max_x -> true
      antinode.y < 0 -> true
      antinode.y > max_y -> true
      true -> false
    end
  end

  defp calculate_antinodes(signal, grid) do
    antennaes = grid |> List.flatten() |> Enum.filter(&(&1.character == signal))

    for a <- antennaes, b <- antennaes, a != b, do: antinodes_for(a, b)
  end

  defp extract_signals(grid) do
    grid
    |> List.flatten()
    |> Enum.filter(&(&1.character != "."))
    |> Enum.map(& &1.character)
    |> Enum.uniq()
  end

  defmodule Grid do
    def parse(file) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.with_index()
      |> Enum.map(fn {line, y_index} -> {Enum.with_index(line), y_index} end)
      |> Enum.map(fn {line, y_index} ->
        Enum.map(line, fn {location, x_index} ->
          %{character: location, x: x_index, y: y_index}
        end)
      end)
      |> then(fn grid ->
        {grid, length(grid) - 1, length(hd(grid)) - 1}
      end)
    end
  end
end
