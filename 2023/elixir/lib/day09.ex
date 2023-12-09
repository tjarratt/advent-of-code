defmodule Day09 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> String.split("\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> Enum.map(&parse/1)
    |> Enum.map(&predict_next_value/1)
    |> Enum.sum()
  end

  defp predict_next_value(sequence) do
    differences = compute_differences(sequence)

    if Enum.uniq(differences) == [0] do
      List.last(sequence)
    else
      List.last(sequence) + predict_next_value(differences)
    end
  end

  defp compute_differences(sequence) do
    sequence
    |> Enum.chunk_every(2, 1)
    |> Enum.reject(fn list -> length(list) == 1 end)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  defp parse(line) do
    line
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end
end
