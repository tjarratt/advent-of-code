defmodule Day19 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> solve()
  end

  defp solve({available, desired}) do
    desired
    |> Enum.filter(&solveable?(&1, available))
    |> length()
  end

  defp solveable?("", _patterns), do: true
  defp solveable?(_desired, []), do: false

  defp solveable?(desired, patterns) do
    Enum.any?(patterns, fn pattern ->
      if String.starts_with?(desired, pattern) do
        ^pattern <> remaining = desired

        solveable?(remaining, patterns)
      else
        false
      end
    end)
  end

  defp parse(input) do
    [available, desired] = String.split(input, "\n\n", trim: true)

    {
      split_lines(available, on: ", "),
      split_lines(desired)
    }
  end
end
