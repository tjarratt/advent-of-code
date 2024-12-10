defmodule Day10 do
  use AocTemplate

  def part_one() do
    {map, starting_points} =
      "input"
      |> read_file!()
      |> split_lines()
      |> Enum.map(&String.split(&1, "", trim: true))
      |> parse_to_map()

    starting_points
    |> Enum.map(&score(&1, [[]], map))
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&length/1)
    |> Enum.sum()
  end

  def part_two() do
    {map, starting_points} =
      "input"
      |> read_file!()
      |> split_lines()
      |> Enum.map(&String.split(&1, "", trim: true))
      |> parse_to_map()

    starting_points
    |> Enum.map(&unique_paths(&1, map))
    |> Enum.sum()
  end

  # # # part 2

  defp unique_paths(trailhead, map) do
    if Map.get(map, trailhead) == "9" do
      1
    else
      [:up, :right, :down, :left]
      |> Enum.map(&next_step?(&1, trailhead, map))
      |> Enum.filter(&(&1 != nil))
      |> Enum.map(&unique_paths(&1, map))
      |> Enum.sum()
    end
  end

  # # # part 1

  defp score(trailhead, trails, map) do
    trails = trails |> Enum.map(&(&1 ++ [trailhead]))

    if Map.get(map, trailhead) == "9" do
      trailhead
    else
      [:up, :right, :down, :left]
      |> Enum.map(&next_step?(&1, trailhead, map))
      |> Enum.filter(&(&1 != nil))
      |> Enum.map(&score(&1, trails, map))
      |> List.flatten()
    end
  end

  defp next_step?(direction, location = {y, x}, map) do
    next_step =
      case direction do
        :up -> {y - 1, x}
        :right -> {y, x + 1}
        :down -> {y + 1, x}
        :left -> {y, x - 1}
      end

    if Map.get(map, next_step) == Map.fetch!(map, location) |> following_marker() do
      next_step
    else
      nil
    end
  end

  defp following_marker(marker) do
    %{
      "0" => "1",
      "1" => "2",
      "2" => "3",
      "3" => "4",
      "4" => "5",
      "5" => "6",
      "6" => "7",
      "7" => "8",
      "8" => "9"
    }
    |> Map.fetch!(marker)
  end

  defp parse_to_map(grid) do
    map =
      grid
      |> Enum.with_index()
      |> Enum.map(fn {row, index} -> {Enum.with_index(row), index} end)
      |> Enum.map(fn {row, y} -> Enum.map(row, fn {value, x} -> {{y, x}, value} end) end)
      |> List.flatten()
      |> Enum.into(Map.new())

    starting_points =
      map
      |> Map.filter(fn {_coords, value} -> value == "0" end)
      |> Map.to_list()
      |> Enum.map(&elem(&1, 0))

    {map, starting_points}
  end
end
