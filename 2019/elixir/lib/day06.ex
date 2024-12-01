defmodule Day06 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> parse_orbits()
    |> count_orbits("COM", 0)
  end

  def part_two() do
    "input"
    |> read_file!()
    |> split_lines()
    |> then(fn lines -> {parse_orbits(lines), parse_orbits(lines, :part_two)} end)
    |> jump_to_santa([{"YOU", 0}], ["YOU"])
  end

  # parses lines to a map of celestial body -> [list, of, satellites]
  defp parse_orbits(lines) do
    lines
    |> Enum.map(&split_lines(&1, on: ")"))
    |> Enum.reduce(%{"COM" => []}, fn [body, satellite], acc ->
      Map.update(acc, body, [satellite], fn list -> list ++ [satellite] end)
    end)
  end

  # like parsing orbits for part 1, but is a map backwards from each satellite back to the body they orbit
  defp parse_orbits(lines, :part_two) do
    lines
    |> Enum.map(&split_lines(&1, on: ")"))
    |> Enum.reduce(%{}, fn [body, satellite], acc ->
      Map.update(acc, satellite, [body], fn list -> list ++ [body] end)
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

  defp jump_to_santa({children, parents} = orbits, considering, seen) do
    new_children =
      considering
      |> Enum.flat_map(fn {body, count} ->
        children
        |> Map.get(body, [])
        |> List.wrap()
        |> Enum.map(fn satellite -> {satellite, count + 1} end)
      end)
      |> Enum.reject(fn {body, _count} -> body == [] end)

    new_parents =
      considering
      |> Enum.flat_map(fn {body, count} ->
        parents
        |> Map.get(body, [])
        |> List.wrap()
        |> Enum.map(fn satellite -> {satellite, count + 1} end)
      end)
      |> Enum.reject(fn {body, _count} -> body == [] end)

    satellites =
      (new_children ++ new_parents) |> Enum.reject(fn {body, _count} -> body in seen end)

    new_seen = seen ++ Enum.map(satellites, &elem(&1, 0))

    # if any are santa, we have our answer
    case Enum.find(satellites, fn {body, _count} -> body == "SAN" end) do
      {"SAN", count} ->
        # we don't count the jump from YOU to what we are in orbit around
        # nor do we count the jump to santa
        count - 2

      nil ->
        # otherwise recurse
        jump_to_santa(orbits, satellites, new_seen)
    end
  end
end
