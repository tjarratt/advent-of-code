defmodule Day03 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> then(fn input -> Regex.scan(~r[(mul\(\d+,\d+\))], input, capture: :first) end)
    |> List.flatten()
    |> Enum.map(&multiply/1)
    |> Enum.sum()
  end

  defp multiply(string) do
    [a, b] =
      Regex.scan(~r[mul\((\d+),(\d+)\)], string, capture: :all_but_first)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    a * b
  end
end
