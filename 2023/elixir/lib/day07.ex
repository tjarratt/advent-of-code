defmodule Day07 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> String.split("\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> Enum.map(&parse/1)
    |> Enum.sort(fn a, b -> rank(a, b) end)
    |> Enum.with_index()
    |> Enum.map(fn {rest, index} -> {index + 1, rest} end)
    |> Enum.map(fn {rank, {_hand, bid}} -> rank * bid end)
    |> Enum.sum()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> String.split("\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> Enum.map(&parse/1)
    |> Enum.sort(fn a, b -> rank_part2(a, b) end)
    |> Enum.with_index()
    |> Enum.map(fn {rest, index} -> {index + 1, rest} end)
    |> Enum.map(fn {rank, {_hand, bid}} -> rank * bid end)
    |> Enum.sum()
  end

  defp rank({first, _bid}, {second, _bid2}) do
    type_order = [
      :five_of_a_kind,
      :four_of_a_kind,
      :full_house,
      :three_of_a_kind,
      :two_pair,
      :one_pair,
      :high_card
    ]

    card_order = ~w(A K Q J T 9 8 7 6 5 4 3 2)

    type_1 = Enum.find_index(type_order, fn x -> x == typeof(first) end)
    type_2 = Enum.find_index(type_order, fn x -> x == typeof(second) end)

    cond do
      type_1 == type_2 -> compare_cards(first, second, card_order)
      true -> type_1 > type_2
    end
  end

  defp rank_part2({first, _bid}, {second, _bid2}) do
    type_order = [
      :five_of_a_kind,
      :four_of_a_kind,
      :full_house,
      :three_of_a_kind,
      :two_pair,
      :one_pair,
      :high_card
    ]

    card_order = ~w(A K Q T 9 8 7 6 5 4 3 2 J)

    type_1 = Enum.find_index(type_order, fn x -> x == typeof_part2(first) end)
    type_2 = Enum.find_index(type_order, fn x -> x == typeof_part2(second) end)

    cond do
      type_1 == type_2 -> compare_cards(first, second, card_order)
      true -> type_1 > type_2
    end
  end

  defp typeof(cards) do
    cards |> sort_by_order |> classify()
  end

  defp typeof_part2(cards) do
    cards |> sort_by_order_part2() |> classify_part2()
  end

  defp sort_by_order(cards) do
    cards
    |> Enum.reduce(%{}, fn x, map -> Map.put(map, x, (map[x] || 0) + 1) end)
    |> Map.to_list()
    |> Enum.sort(fn {_, x}, {_, y} -> x > y end)
    |> Enum.map(fn {char, count} -> List.duplicate(char, count) end)
    |> List.flatten()
  end

  defp sort_by_order_part2(cards) do
    cards
    |> Enum.reduce(%{}, fn x, map -> Map.put(map, x, (map[x] || 0) + 1) end)
    |> Map.to_list()
    |> Enum.sort(fn {card1, x}, {card2, y} ->
      cond do
        card1 == "J" -> false
        card2 == "J" -> true
        true -> x > y
      end
    end)
    |> Enum.map(fn {char, count} -> List.duplicate(char, count) end)
    |> List.flatten()
  end

  defp classify([a, a, a, a, a]), do: :five_of_a_kind
  defp classify([a, a, a, a, _]), do: :four_of_a_kind
  defp classify([a, a, a, b, b]), do: :full_house
  defp classify([a, a, a, _, _]), do: :three_of_a_kind
  defp classify([a, a, b, b, _]), do: :two_pair
  defp classify([a, a, _, _, _]), do: :one_pair
  defp classify(_), do: :high_card

  defp classify_part2([a, a, a, a, a]), do: :five_of_a_kind
  defp classify_part2([a, a, a, a, "J"]), do: :five_of_a_kind
  defp classify_part2([a, a, a, "J", "J"]), do: :five_of_a_kind
  defp classify_part2([a, a, "J", "J", "J"]), do: :five_of_a_kind
  defp classify_part2([_, "J", "J", "J", "J"]), do: :five_of_a_kind

  defp classify_part2([a, a, a, a, _]), do: :four_of_a_kind
  defp classify_part2([a, a, a, _, "J"]), do: :four_of_a_kind
  defp classify_part2([a, a, _, "J", "J"]), do: :four_of_a_kind
  defp classify_part2([_a, _, "J", "J", "J"]), do: :four_of_a_kind

  defp classify_part2([a, a, a, b, b]), do: :full_house
  defp classify_part2([a, a, b, b, "J"]), do: :full_house
  defp classify_part2([_a, b, b, "J", "J"]), do: :full_house
  defp classify_part2([a, a, a, _b, "J"]), do: :full_house

  defp classify_part2([a, a, a, _, _]), do: :three_of_a_kind
  defp classify_part2([a, a, _, _, "J"]), do: :three_of_a_kind
  defp classify_part2([_a, _, _, "J", "J"]), do: :three_of_a_kind

  defp classify_part2([a, a, b, b, _]), do: :two_pair

  defp classify_part2([a, a, _, _, _]), do: :one_pair
  defp classify_part2([_a, _, _, _, "J"]), do: :one_pair
  defp classify_part2(_), do: :high_card

  defp compare_cards(first_cards, second_cards, order) do
    str_1 = Enum.map(first_cards, fn card -> Enum.find_index(order, fn x -> x == card end) end)
    str_2 = Enum.map(second_cards, fn card -> Enum.find_index(order, fn x -> x == card end) end)

    compare_strengths(str_1, str_2)
  end

  defp compare_strengths([a], [b]), do: a > b

  defp compare_strengths([a | rest_a], [b | rest_b]) do
    if a == b do
      compare_strengths(rest_a, rest_b)
    else
      a > b
    end
  end

  defp parse(line) do
    [hand, bid] = String.split(line, " ")

    {
      String.split(hand, "", trim: true),
      String.to_integer(bid)
    }
  end
end
