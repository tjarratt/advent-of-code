defmodule Day03 do
  def part_one() do
    "input"
    |> read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, ",") end)
    |> Enum.map(&to_points/1)
    |> (fn wires -> find_intersections(wires) end).()
    |> MapSet.to_list()
    |> Enum.map(&manhattan_distance/1)
    |> first_non_negative()
  end

  defp first_non_negative(list) do
    list |> Enum.sort() |> Enum.find(fn x -> x != 0 end)
  end

  defp manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end

  defp find_intersections([first, second]) do
    MapSet.new(first)
    |> MapSet.intersection(MapSet.new(second))
  end

  defp to_points(line) do
    to_points(line, {0, 0})
  end

  defp to_points([], _), do: []

  defp to_points(line, {x, y} = point) do
    [dir | rest] = line

    # problem : we want to return the next point we're iterating from
    # but this currently returns the entire list of points we have
    # traversed by following the current direction
    # need to actually flatten this data structure
    # and pull out next by hand
    next =
      case parse(dir) do
        {"R", amount} -> {x + amount, y}
        {"L", amount} -> {x - amount, y}
        {"U", amount} -> {x, y + amount}
        {"D", amount} -> {x, y - amount}
      end

    intermediate_points = walk(point, next)

    [intermediate_points | to_points(rest, next)] |> List.flatten()
  end

  defp walk({x, y}, {x2, y}) do
    for x_prime <- x..x2 do
      {x_prime, y}
    end
  end

  defp walk({x, y}, {x, y2}) do
    for y_prime <- y..y2 do
      {x, y_prime}
    end
  end

  def parse(string) do
    {dir, amount_string} = String.split_at(string, 1)

    {dir, String.to_integer(amount_string)}
  end

  defp read_file(name) do
    File.read!(Path.join(["resources", "03", name]))
  end
end
