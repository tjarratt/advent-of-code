defmodule Day18 do
  use AocTemplate

  def part_one() do
    instructions =
      "input"
      |> read_file!()
      |> split_lines()
      |> Enum.map(&parse/1)

    start = {0, 0}

    instructions
    |> dig_out_lagoon([start], start)
    |> calculate_area_using_shoelace()
  end

  defp calculate_area_using_shoelace(digsite) do
    digsite
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [{y1, x1}, {y2, x2}], sum ->
      sum + x1 * y2 - x2 * y1
    end)
    |> (fn sum -> sum + length(digsite) + 1 end).()
    |> Integer.floor_div(2)
  end

  def to_grid(digsite) do
    min_y = Enum.map(digsite, &elem(&1, 0)) |> Enum.min()
    max_y = Enum.map(digsite, &elem(&1, 0)) |> Enum.max()

    min_x = Enum.map(digsite, &elem(&1, 1)) |> Enum.min()
    max_x = Enum.map(digsite, &elem(&1, 1)) |> Enum.max()

    min_y..max_y
    |> Enum.map(fn y ->
      min_x..max_x
      |> Enum.map(fn x ->
        if {y, x} in digsite do
          "#"
        else
          "."
        end
      end)
    end)
  end

  defp dig_out_lagoon([], digsite, _location), do: digsite

  defp dig_out_lagoon(instructions, digsite, location) do
    [instruction | rest] = instructions

    {next_location, freshly_dug} = dig(from: location, following: instruction)

    dig_out_lagoon(rest, digsite ++ freshly_dug, next_location)
  end

  defp dig(from: {y, x} = current, following: {dir, distance, _rgb}) do
    next_location =
      case dir do
        "R" -> {y, x + distance}
        "L" -> {y, x - distance}
        "U" -> {y - distance, x}
        "D" -> {y + distance, x}
      end

    freshly_dug = squares_between(current, next_location)

    {next_location, freshly_dug}
  end

  defp squares_between({y, x}, {yprime, x}) do
    if yprime > y do
      1..(yprime - y)
      |> Enum.map(fn diff -> {y + diff, x} end)
    else
      1..(y - yprime)
      |> Enum.map(fn diff -> {y - diff, x} end)
    end
  end

  defp squares_between({y, x}, {y, xprime}) do
    if xprime > x do
      1..(xprime - x)
      |> Enum.map(fn diff -> {y, x + diff} end)
    else
      1..(x - xprime)
      |> Enum.map(fn diff -> {y, x - diff} end)
    end
  end

  defp parse(line) do
    [dir, size, rest] = String.split(line, " ")

    <<_lparen::binary-size(1), _hash::binary-size(1), hex::binary-size(6),
      _rparens::binary-size(1)>> = rest

    [red, blue, green] =
      hex
      |> String.split("", trim: true)
      |> Enum.chunk_every(2)
      |> Enum.map(&Enum.join(&1, ""))

    {dir, String.to_integer(size), {red, green, blue}}
  end
end
