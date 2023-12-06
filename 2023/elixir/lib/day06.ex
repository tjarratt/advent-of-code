defmodule Day06 do
  use AocTemplate

  def part_one() do
    # boat starts at zero millimeters per second
    # each second you hold it down it increases by 1 millimeter per second
    # count number of ways we could beat the record for each race
    # multiple all the values together

    "input"
    |> read_file!()
    |> String.split("\n", trim: true)
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> parse_races()
    |> Enum.map(&count_ways_to_win/1)
    |> Enum.product()
  end

  defp count_ways_to_win({time, distance}) do
    1..time
    |> Enum.map(fn t -> {time - t, t} end)
    |> Enum.filter(fn {time_remaining, speed} -> time_remaining * speed > distance end)
    |> Enum.count()
  end

  defp parse_races(lines) do
    [first, second] = lines
    [_label | times] = String.split(first, " ", trim: true)
    [_label | distances] = String.split(second, " ", trim: true)

    Enum.zip(
      Enum.map(times, &String.to_integer/1),
      Enum.map(distances, &String.to_integer/1)
    )
  end
end
