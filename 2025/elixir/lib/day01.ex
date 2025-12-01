defmodule Day01 do
  use AocTemplate

  @initial_position 50

  def part_one() do
    {_final, intermediates} =
      "input"
      |> read_file!()
      |> split_lines()
      |> parse()
      |> Enum.reduce({@initial_position, []}, &do_reduce/2)

    intermediates |> Enum.filter(&(&1 == 0)) |> Enum.count()
  end

  defp do_reduce({direction, how_much}, {current, all_positions}) do
    next_position = turn(current, direction, how_much)

    {next_position, [next_position | all_positions]}
  end

  defp turn(current, :left, how_much) do
    (current - how_much) |> Integer.mod(100)
  end

  defp turn(current, :right, how_much) do
    (current + how_much) |> Integer.mod(100)
  end

  defp parse(lines) do
    lines
    |> Enum.map(&parse_line/1)
  end

  defp parse_line("L" <> rest) do
    how_much = String.to_integer(rest)
    {:left, how_much}
  end

  defp parse_line("R" <> rest) do
    how_much = String.to_integer(rest)
    {:right, how_much}
  end
end
