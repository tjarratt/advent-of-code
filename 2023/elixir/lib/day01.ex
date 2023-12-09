defmodule Day01 do
  use AocTemplate

  @words_to_numbers %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(&read_calibration_value/1)
    |> Enum.sum()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(&number_as_words_to_digits/1)
    |> Enum.map(&number_as_words_to_digits_backwards/1)
    |> Enum.map(&read_calibration_value/1)
    |> Enum.sum()
  end

  def number_as_words_to_digits(line) do
    if String.length(line) < 3 do
      line
    else
      cond do
        take_first(line, 3) in Map.keys(@words_to_numbers) ->
          {word, rest_of_line} = String.split_at(line, 3)
          @words_to_numbers[word] <> word <> rest_of_line

        take_first(line, 4) in Map.keys(@words_to_numbers) ->
          {word, rest_of_line} = String.split_at(line, 4)
          @words_to_numbers[word] <> word <> rest_of_line

        take_first(line, 5) in Map.keys(@words_to_numbers) ->
          {word, rest_of_line} = String.split_at(line, 5)
          @words_to_numbers[word] <> word <> rest_of_line

        true ->
          {char, rest_of_line} = String.split_at(line, 1)
          char <> number_as_words_to_digits(rest_of_line)
      end
    end
  end

  def number_as_words_to_digits_backwards(line) do
    if String.length(line) < 3 do
      line
    else
      cond do
        take_last(line, 3) in Map.keys(@words_to_numbers) ->
          {rest_of_line, word} = String.split_at(line, String.length(line) - 3)
          rest_of_line <> word <> @words_to_numbers[word]

        take_last(line, 4) in Map.keys(@words_to_numbers) ->
          {rest_of_line, word} = String.split_at(line, String.length(line) - 4)
          rest_of_line <> word <> @words_to_numbers[word]

        take_last(line, 5) in Map.keys(@words_to_numbers) ->
          {rest_of_line, word} = String.split_at(line, String.length(line) - 5)
          rest_of_line <> word <> @words_to_numbers[word]

        true ->
          {rest_of_line, char} = line |> String.split_at(String.length(line) - 1)
          number_as_words_to_digits_backwards(rest_of_line) <> char
      end
    end
  end

  defp take_first(str, num) do
    {result, _} = String.split_at(str, num)

    result
  end

  defp take_last(str, num) do
    {_, result} = String.split_at(str, String.length(str) - num)

    result
  end

  def read_calibration_value(line) do
    digits =
      line
      |> String.split("", trim: true)
      |> Enum.filter(fn str -> str =~ ~r([0-9]) end)

    String.to_integer(List.first(digits) <> List.last(digits))
  end
end
