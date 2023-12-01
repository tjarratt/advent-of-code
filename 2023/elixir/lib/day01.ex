defmodule Day01 do
  def part_one() do
    "input"
    |> read_file()
    |> String.split("\n")
    |> Enum.filter(fn line -> String.length(line) > 0 end)
    |> Enum.map(fn line -> String.split(line, "", trim: true) end)
    |> Enum.map(fn line -> Enum.filter(line, fn str -> str =~ ~r([0-9]) end) end)
    |> Enum.map(fn line -> numberify(line) end)
    |> Enum.sum()
  end

  defp numberify(list) do
    String.to_integer(List.first(list) <> List.last(list))
  end

  defp read_file(path) do
    File.read!(Path.join(["resources", "01", path]))
  end
end
