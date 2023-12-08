defmodule Day08 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> String.split("\n\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> (fn [instructions, map] ->
          {
            String.split(instructions, "", trim: true),
            parse_map(map)
          }
        end).()
    |> walk(from: "AAA", steps: 0)
  end

  defp walk({_instructions, _map}, from: "ZZZ", steps: count), do: count

  defp walk({instructions, map}, from: location, steps: count) do
    # read first instruction , put it at the end
    [next_instruction | rest] = instructions
    new_instructions = rest ++ [next_instruction]

    # read current map location
    {_, go_left, go_right} = Enum.find(map, fn {node, _left, _right} -> node == location end)

    # set next location to L or R
    next_location =
      case next_instruction do
        "L" -> go_left
        "R" -> go_right
        _ -> raise "Where did you get that #{next_instruction} ?"
      end

    # recurse
    walk({new_instructions, map}, from: next_location, steps: count + 1)
  end

  defp parse_map(string) do
    string
    |> String.split("\n")
    |> Enum.reject(fn line -> String.length(line) == 0 end)
    |> Enum.map(&parse/1)
  end

  defp parse(line) do
    [head, rest] = String.split(line, " = ")

    <<_lparen::binary-size(1), inner::binary-size(8), _rparen::binary-size(1)>> = rest
    [left, right] = String.split(inner, ", ")

    {head, left, right}
  end
end
