defmodule Day05 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> String.split("\n\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> (fn [head | rest] -> {parse_seeds(head), parse_maps(rest)} end).()
    |> (fn {seeds, maps} -> Enum.map(seeds, &map_seed_to_location(&1, maps)) end).()
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.sort()
    |> hd()
  end

  defp map_seed_to_location(seed, maps) do
    [
      seed,
      seed
      |> check_ranges(Map.get(maps, "seed-to-soil"))
      |> check_ranges(Map.get(maps, "soil-to-fertilizer"))
      |> check_ranges(Map.get(maps, "fertilizer-to-water"))
      |> check_ranges(Map.get(maps, "water-to-light"))
      |> check_ranges(Map.get(maps, "light-to-temperature"))
      |> check_ranges(Map.get(maps, "temperature-to-humidity"))
      |> check_ranges(Map.get(maps, "humidity-to-location"))
    ]
  end

  defp check_ranges(input, ranges) do
    range =
      Enum.find(ranges, fn {source, _destination} -> input in source end)

    if range == nil do
      input
    else
      map_source_to_destination(input, range)
    end
  end

  defp map_source_to_destination(input, {source, destination}) do
    source_start.._end = source
    destination_start.._end = destination
    destination_start + (input - source_start)
  end

  defp parse_seeds(raw) do
    "seeds: " <> rest = raw

    rest |> String.split(" ") |> Enum.map(&String.to_integer/1)
  end

  defp parse_maps(lines) do
    Enum.reduce(lines, %{}, fn line, acc ->
      {name, ranges} = parse_map(line)
      Map.put(acc, name, ranges)
    end)
  end

  defp parse_map(raw) do
    [name | lines] =
      String.split(raw, "\n") |> Enum.reject(fn line -> String.length(line) == 0 end)

    {
      String.replace(name, " map:", ""),
      Enum.map(lines, &parse_ranges/1)
    }
  end

  defp parse_ranges(list) do
    [destination, source, length] =
      list |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

    {
      source..(source + length - 1),
      destination..(destination + length - 1)
    }
  end
end
