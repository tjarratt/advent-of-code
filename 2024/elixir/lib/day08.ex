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

  def part_two() do
    "input"
    |> read_file!()
    |> Grid.parse()
    |> find_antinodes(:part_two)
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

  defp antinodes_for(a, b, :part_two) do
    dx = a.x - b.x
    dy = b.y - a.y

    [
      Stream.unfold(0, fn iteration ->
        result = %{x: a.x + iteration * dx, y: a.y - iteration * dy}

        {result, iteration + 1}
      end),
      Stream.unfold(0, fn iteration ->
        result = %{x: b.x - iteration * dx, y: b.y + iteration * dy}

        {result, iteration + 1}
      end)
    ]
  end

  defp find_antinodes({grid, max_y, max_x}) do
    grid
    |> extract_signals()
    |> Enum.map(&calculate_antinodes(&1, grid))
    |> List.flatten()
    |> Enum.filter(&inside_grid?(&1, max_y, max_x))
  end

  defp find_antinodes({grid, max_y, max_x}, :part_two) do
    grid
    |> extract_signals()
    |> Enum.map(&calculate_antinodes_with_resonant_harmonics(&1, grid))
    |> List.flatten()
    |> Enum.flat_map(fn stream -> Stream.take_while(stream, &inside_grid?(&1, max_y, max_x)) end)
  end

  defp inside_grid?(antinode, max_y, max_x) do
    cond do
      antinode.x < 0 -> false
      antinode.x > max_x -> false
      antinode.y < 0 -> false
      antinode.y > max_y -> false
      true -> true
    end
  end

  defp calculate_antinodes(signal, grid) do
    antennaes = grid |> List.flatten() |> Enum.filter(&(&1.character == signal))

    for a <- antennaes, b <- antennaes, a != b, do: antinodes_for(a, b)
  end

  defp calculate_antinodes_with_resonant_harmonics(signal, grid) do
    antennaes = grid |> List.flatten() |> Enum.filter(&(&1.character == signal))

    for a <- antennaes, b <- antennaes, a != b, do: antinodes_for(a, b, :part_two)
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
