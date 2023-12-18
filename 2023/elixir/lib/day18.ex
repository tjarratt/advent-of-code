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

  def part_two() do
    instructions =
      "input"
      |> read_file!()
      |> split_lines()
      |> Enum.map(&parse_electric_boogaloo/1)

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
    |> (fn sum -> sum + perimeter(digsite) + 2 end).()
    |> Integer.floor_div(2)
  end

  defp perimeter(digsite) do
    digsite
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&distance_between(&1))
    |> Enum.sum()
  end

  defp distance_between([{y1, x1}, {y2, x2}]) do
    abs(y2 - y1) + abs(x2 - x1)
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

    next_location = dig(from: location, following: instruction)

    dig_out_lagoon(rest, digsite ++ [next_location], next_location)
  end

  defp dig(from: {y, x}, following: {dir, distance}) do
    case dir do
      "R" -> {y, x + distance}
      "L" -> {y, x - distance}
      "U" -> {y - distance, x}
      "D" -> {y + distance, x}
    end
  end

  defp parse(line) do
    [dir, size, _rest] = String.split(line, " ")

    {dir, String.to_integer(size)}
  end

  defp parse_electric_boogaloo(line) do
    [_dir, _size, hex] = String.split(line, " ")

    <<_lparen::binary-size(1), _hash::binary-size(1), hex::binary-size(6),
      _rparens::binary-size(1)>> = hex

    {first, last} = String.split_at(hex, 5)

    dir =
      case last do
        "0" -> "R"
        "1" -> "D"
        "2" -> "L"
        "3" -> "U"
      end

    {distance, ""} = Integer.parse(first, 16)

    {dir, distance}
  end
end
