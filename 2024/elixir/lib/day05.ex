defmodule Day05 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> String.split("\n\n")
    |> then(fn [rules, updates] -> {parse(rules, :rules), parse(updates, :updates)} end)
    |> filter_valid()
    |> Enum.map(&middle_page/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> String.split("\n\n")
    |> then(fn [rules, updates] -> {parse(rules, :rules), parse(updates, :updates)} end)
    |> filter_invalid()
    |> correct_ordering()
    |> Enum.map(&middle_page/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp correct_ordering({rules, updates}) do
    Enum.map(
      updates,
      &Enum.sort(&1, fn a, b ->
        cond do
          a in Map.get(rules, b, []) -> false
          b in Map.get(rules, a, []) -> true
          true -> true
        end
      end)
    )
  end

  defp filter_invalid({rules, updates}) do
    updates
    |> Enum.map(&Enum.reverse/1)
    |> Enum.filter(&out_of_order?(&1, rules))
    |> Enum.map(&Enum.reverse/1)
    |> then(fn updates -> {rules, updates} end)
  end

  defp filter_valid({rules, updates}) do
    updates
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reject(&out_of_order?(&1, rules))
  end

  # for each page (in reverse order)
  # check if any of the preceeding pages should have followed it
  defp out_of_order?([page | earlier_pages], rules) do
    must_appear_after = Map.get(rules, page, []) |> MapSet.new()

    if MapSet.disjoint?(must_appear_after, MapSet.new(earlier_pages)) do
      out_of_order?(earlier_pages, rules)
    else
      true
    end
  end

  # base case, if we've hit here, then no pages appeared before this one
  defp out_of_order?(_page, _rules), do: false

  # returns the map which yields the pages that must appear after a given page
  defp parse(rules, :rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split("|") end)
    |> Enum.reduce(%{}, fn [page, followed_by], acc ->
      Map.update(acc, page, [followed_by], fn existing -> existing ++ [followed_by] end)
    end)
  end

  defp parse(updates, :updates) do
    updates
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.split(",") end)
  end

  defp middle_page(update) do
    index = ((length(update) - 1) / 2) |> floor()

    Enum.at(update, index)
  end
end
