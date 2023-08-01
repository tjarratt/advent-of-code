defmodule Day02 do
  def part_one do
    "input"
    |> read_file()
    |> String.split("\n")
    |> Enum.reject(fn str -> String.length(str) == 0 end)
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> Enum.map(&parse/1)
    |> Enum.map(&outcome/1)
    |> Enum.map(fn [outcome, choice] -> score(outcome) + score(choice) end)
    |> Enum.sum()
  end

  def score(result) do
    case result do
      :win -> 6
      :draw -> 3
      :loss -> 0
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end
  end

  def outcome([opponent_choice, player_choice]) do
    outcome =
      case [opponent_choice, player_choice] do
        # draws
        [:rock, :rock] -> :draw
        [:paper, :paper] -> :draw
        [:scissors, :scissors] -> :draw
        # losses
        [:rock, :scissors] -> :loss
        [:paper, :rock] -> :loss
        [:scissors, :paper] -> :loss
        # wins
        [:rock, :paper] -> :win
        [:paper, :scissors] -> :win
        [:scissors, :rock] -> :win
      end

    [outcome, player_choice]
  end

  def parse([opponent, player]) do
    [parse(opponent), parse(player)]
  end

  def parse("A") do
    :rock
  end

  def parse("B") do
    :paper
  end

  def parse("C") do
    :scissors
  end

  def parse("X") do
    :rock
  end

  def parse("Y") do
    :paper
  end

  def parse("Z") do
    :scissors
  end

  def read_file(path) do
    case File.read(Path.join(["resources", "2", path])) do
      {:ok, content} ->
        content

      {:error, reason} ->
        IO.puts("Error reading file #{path} : #{reason}")
        nil
    end
  end
end
