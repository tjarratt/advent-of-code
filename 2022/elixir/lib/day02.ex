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

  def part_two do
    "input"
    |> read_file()
    |> String.split("\n")
    |> Enum.reject(fn str -> String.length(str) == 0 end)
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> Enum.map(&parse_part_2/1)
    |> Enum.map(&outcome_part_2/1)
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

  def outcome_part_2([opponent_choice, strategy]) do
    player_choice =
      case [opponent_choice, strategy] do
        [:rock, :win] -> :paper
        [:paper, :win] -> :scissors
        [:scissors, :win] -> :rock
        [:rock, :draw] -> :rock
        [:paper, :draw] -> :paper
        [:scissors, :draw] -> :scissors
        [:rock, :loss] -> :scissors
        [:paper, :loss] -> :rock
        [:scissors, :loss] -> :paper
      end

    [strategy, player_choice]
  end

  def parse_part_2([opponent, player]) do
    [parse(opponent), parse_strategy(player)]
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

  def parse_strategy("X") do
    :loss
  end

  def parse_strategy("Y") do
    :draw
  end

  def parse_strategy("Z") do
    :win
  end

  # pragma mark - input
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
