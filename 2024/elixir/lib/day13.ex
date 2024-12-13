defmodule Day13 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> Enum.map(&solveable?/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&to_tokens/1)
    |> Enum.sum()
  end

  defp to_tokens([a_presses, b_presses]) do
    a_presses * 3 + b_presses
  end

  defp solveable?({[ax, ay], [bx, by], [px, py]}) do
    solutions =
      for a_presses <- 0..100, b_presses <- 0..100 do
        if a_presses * ax + b_presses * bx == px and
             a_presses * ay + b_presses * by == py do
          [a_presses, b_presses]
        end
      end

    valid =
      solutions
      |> Enum.reject(&is_nil/1)
      |> Enum.sort(fn one, two ->
        one = one |> Enum.map(&length/1) |> Enum.sum()
        two = two |> Enum.map(&length/1) |> Enum.sum()

        one < two
      end)

    case valid do
      [] -> nil
      [best | _others] -> best
    end
  end

  defp parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn lines ->
      [a, b, prize] = String.split(lines, "\n", trim: true)

      {parse_line(a), parse_line(b), parse_line(prize)}
    end)
  end

  defp parse_line(string) do
    Regex.scan(~r[(\d+)], string, capture: :first)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
