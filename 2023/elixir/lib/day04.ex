defmodule Day04 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(&parse_gamecard/1)
    |> Enum.map(&count_winning_numbers/1)
    |> Enum.map(&points_for/1)
    |> Enum.sum()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(&parse_gamecard/1)
    |> Enum.map(fn card -> {card, 1} end)
    |> sum_up_scorecards(0)
    |> Enum.map(fn {_card, num_copies} -> num_copies end)
    |> Enum.sum()
  end

  defp sum_up_scorecards(cards, index) when index >= length(cards), do: cards

  defp sum_up_scorecards(cards, index) do
    {card, copies_to_make} = Enum.at(cards, index)
    winning_numbers = count_winning_numbers(card)

    updated_cards = copy_cards(cards, index, winning_numbers, copies_to_make)

    sum_up_scorecards(updated_cards, index + 1)
  end

  defp copy_cards(cards, _index, offset, _copies_to_make) when offset == 0, do: cards

  defp copy_cards(cards, index, offset, copies_to_make) do
    cards
    |> List.update_at(index + offset, fn {card, num_copies} ->
      {card, num_copies + copies_to_make}
    end)
    |> copy_cards(index, offset - 1, copies_to_make)
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
    "Card " <> raw_number = game
    number = raw_number |> String.trim_leading() |> String.to_integer()

    [winning_numbers, our_numbers] =
      rest
      |> String.split(" | ")
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

    {number, winning_numbers, our_numbers}
  end
end
