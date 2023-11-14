defmodule Day03 do
  def part_one do
    "input"
    |> read_file()
    |> String.split("\n")
    |> Enum.reject(fn str -> String.length(str) == 0 end)
    |> Enum.map(fn str -> String.split(str, "", trim: true) end)
    |> Enum.map(fn rucksack -> Enum.chunk_every(rucksack, floor(length(rucksack) / 2)) end)
    |> Enum.map(fn rucksack -> Enum.map(rucksack, &MapSet.new/1) end)
    |> Enum.map(fn [first, second] -> MapSet.intersection(first, second) end)
    |> Enum.map(&MapSet.to_list/1)
    |> Enum.map(&hd/1)
    |> Enum.map(&priority_for/1)
    |> Enum.sum()
  end

  def priority_for(item) do
    base = to_ordinal(item)

    if item == String.upcase(item) do
      base - to_ordinal("A") + 27
    else
      base - to_ordinal("a") + 1
    end
  end

  defp to_ordinal(str) do
    str |> String.to_charlist() |> hd
  end

  defp read_file(path) do
    File.read!(Path.join(["resources", "3", path]))
  end
end
