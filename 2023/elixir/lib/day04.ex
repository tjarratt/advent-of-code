defmodule Day04 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> String.split("\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> Enum.map(&parse_gamecard/1)
    |> Enum.map(&count_winning_numbers/1)
    |> Enum.map(&points_for/1)
    |> Enum.sum()
  end

  def part_two() do
    "not yet"
  end

  defp points_for(0), do: 0
  defp points_for(1), do: 1

  defp points_for(number_winning_cards) do
    2 * points_for(number_winning_cards - 1)
  end

  defp count_winning_numbers({_card, winning, ours}) do
    MapSet.intersection(
      MapSet.new(winning),
      MapSet.new(ours)
    )
    |> MapSet.size()
  end

  defp parse_gamecard(line) do
    [game, rest] = String.split(line, ": ")
    "Card " <> number = game

    [winning_numbers, our_numbers] =
      rest
      |> String.split(" | ")
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

    {number, winning_numbers, our_numbers}
  end
end
