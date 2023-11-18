defmodule Day04 do
  def part_one() do
    # It is a six-digit number.
    # The value is within the range given in your puzzle input.
    # Two adjacent digits are the same (like 22 in 122345).
    # Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

    "input"
    |> read_file()
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> to_range()
    |> Enum.filter(&valid_password?/1)
    |> length()
  end

  defp to_range([start, stop]), do: start..stop

  defp valid_password?(input) do
    digits = input |> Integer.to_string() |> String.split("", trim: true)

    has_adjacent =
      digits
      |> Enum.chunk_every(2, 1)
      |> Enum.any?(&adjacent?/1)

    has_ascending =
      digits
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
      |> Enum.all?(&strictly_ascending?/1)

    has_adjacent && has_ascending && length(digits) == 6
  end

  defp adjacent?([_]), do: false
  defp adjacent?([a, b]), do: a == b

  defp strictly_ascending?([_]), do: true
  defp strictly_ascending?([a, b]), do: a <= b

  defp read_file(name) do
    File.read!(Path.join(["resources", "04", name]))
    |> String.trim()
  end
end
