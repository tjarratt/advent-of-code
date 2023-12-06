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

  def part_two() do
    "input"
    |> read_file!()
    |> String.split("\n\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> (fn [head | rest] -> {parse_seeds_part2(head), parse_maps_part2(rest)} end).()
    |> (fn {seed_ranges, maps} -> find_lowest_location_in_seed_ranges(seed_ranges, maps, 0) end).()
  end

  defp find_lowest_location_in_seed_ranges(seed_ranges, maps, current_location) do
    # start with location 0
    # reverse the calculation from location -> seed
    # check if it's in on one of the provided seed ranges
    # otherwise, increment location and recurse

    seed = map_location_to_seed(current_location, maps)
    range = Enum.find(seed_ranges, fn r -> seed in r end)

    if range == nil do
      find_lowest_location_in_seed_ranges(seed_ranges, maps, current_location + 1)
    else
      current_location
    end
  end

  defp map_location_to_seed(location, maps) do
    maps
    |> Enum.reverse()
    |> Enum.reduce(location, fn map, value -> reverse_map_input_to_range(value, map) end)
  end

  defp map_seed_to_location(seed, maps) do
    [
      seed,
      seed
      |> map_input_to_range(Map.get(maps, "seed-to-soil"))
      |> map_input_to_range(Map.get(maps, "soil-to-fertilizer"))
      |> map_input_to_range(Map.get(maps, "fertilizer-to-water"))
      |> map_input_to_range(Map.get(maps, "water-to-light"))
      |> map_input_to_range(Map.get(maps, "light-to-temperature"))
      |> map_input_to_range(Map.get(maps, "temperature-to-humidity"))
      |> map_input_to_range(Map.get(maps, "humidity-to-location"))
    ]
  end

  defp reverse_map_input_to_range(value, range) do
    range = Enum.find(range, fn {_source, destination} -> value in destination end)

    if range == nil do
      value
    else
      map_destination_to_source(value, range)
    end
  end

  defp map_input_to_range(value, ranges) do
    range =
      Enum.find(ranges, fn {source, _destination} -> value in source end)

    if range == nil do
      value
    else
      map_source_to_destination(value, range)
    end
  end

  defp map_destination_to_source(value, {source, destination}) do
    source_start.._source_end = source
    destination_start.._destintaion_end = destination

    source_start + (value - destination_start)
  end

  defp map_source_to_destination(value, {source, destination}) do
    source_start.._end = source
    destination_start.._end = destination
    destination_start + (value - source_start)
  end

  defp parse_seeds(raw) do
    "seeds: " <> rest = raw

    rest |> String.split(" ") |> Enum.map(&String.to_integer/1)
  end

  defp parse_seeds_part2(raw) do
    "seeds: " <> rest = raw

    rest
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, length] -> start..(start + length - 1) end)
  end

  defp parse_maps(lines) do
    Enum.reduce(lines, %{}, fn line, acc ->
      {name, ranges} = parse_map(line)
      Map.put(acc, name, ranges)
    end)
  end

  defp parse_maps_part2(lines) do
    Enum.map(lines, fn line ->
      {_name, ranges} = parse_map(line)
      ranges
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
