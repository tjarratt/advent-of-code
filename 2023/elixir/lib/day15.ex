defmodule Day15 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.flat_map(&String.split(&1, ","))
    |> Enum.map(&hash_step/1)
    |> Enum.sum()
  end

  defp hash_step(step) do
    step
    |> String.split("", trim: true)
    |> Enum.reduce(0, fn char, acc ->
      char
      |> String.to_charlist()
      |> hd()
      |> (fn x -> acc + x end).()
      |> (fn x -> x * 17 end).()
      |> rem(256)
    end)
  end
end
