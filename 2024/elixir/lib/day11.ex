defmodule Day11 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> blink(times: 25)
    |> length()
  end

  defp blink(stones, times: 0), do: stones

  defp blink(stones, times: how_many) do
    stones
    |> Enum.map(&evolve/1)
    |> List.flatten()
    |> blink(times: how_many - 1)
  end

  defp evolve(stone) do
    digits = Integer.digits(stone)

    cond do
      stone == 0 ->
        1

      length(digits) |> Integer.mod(2) == 0 ->
        {first, second} = Enum.split(digits, Integer.floor_div(length(digits), 2))
        [Integer.undigits(first), Integer.undigits(second)]

      true ->
        stone * 2024
    end
  end
end
