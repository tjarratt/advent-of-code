defmodule Day02 do
  def part_one() do
    "input"
    |> read_file()
    |> String.split("\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> Enum.map(&parse_games/1)
    |> Enum.filter(&possible/1)
    |> Enum.map(fn game -> game.number end)
    |> Enum.sum()
  end

  def part_two() do
    "not yet"
  end

  defp possible(game) do
    # 12 red cubes, 13 green cubes, and 14 blue cubes
    Enum.all?(game.rounds, fn round ->
      round.red <= 12 && round.green <= 13 && round.blue <= 14
    end)
  end

  defp parse_games(line) do
    [game, rest] = String.split(line, ": ")
    <<"Game ", number::binary>> = game

    %{number: String.to_integer(number), rounds: parse_rounds(rest)}
  end

  defp parse_rounds(line) do
    line
    |> String.split("; ")
    |> Enum.map(&String.split(&1, ", "))
    |> Enum.map(fn rounds ->
      Enum.reduce(rounds, %{red: 0, green: 0, blue: 0}, fn round, acc ->
        [num, color] = String.split(round, " ")
        Map.put(acc, String.to_atom(color), String.to_integer(num))
      end)
    end)
  end

  defp read_file(name) do
    File.read!(Path.join(["resources", "02", name]))
  end
end
