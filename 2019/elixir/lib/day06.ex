defmodule Day06 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> parse_orbits()
    |> count_orbits("COM", 0)
  end

  defp parse_orbits(lines) do
    lines
    |> Enum.map(&split_lines(&1, on: ")"))
    |> Enum.reduce(%{"COM" => []}, fn [body, satellite], acc ->
      Map.update(acc, body, [satellite], fn list -> list ++ [satellite] end)
    end)
  end

  defp count_orbits(orbits, body, depth) do
    satellite_orbits =
      orbits
      |> Map.get(body, [])
      |> Enum.map(&count_orbits(orbits, &1, depth + 1))
      |> Enum.sum()

    depth + satellite_orbits
  end
end
