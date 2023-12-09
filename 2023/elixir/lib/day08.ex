defmodule Day08 do
  use AocTemplate
  import BasicMaths

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines(on: "\n\n")
    |> (fn [instructions, map] ->
          {
            String.split(instructions, "", trim: true),
            parse_map(map)
          }
        end).()
    |> walk(from: "AAA", steps: 0, halt_when: fn str -> str === "ZZZ" end)
  end

  def part_two() do
    "input"
    |> read_file!()
    |> split_lines(on: "\n\n")
    |> (fn [instructions, map] ->
          {
            String.split(instructions, "", trim: true),
            parse_map(map)
          }
        end).()
    |> (fn {instructions, map} ->
          starting_locations =
            map
            |> Enum.map(fn {node, _left, _right} -> node end)
            |> Enum.filter(&String.ends_with?(&1, "A"))

          Enum.map(
            starting_locations,
            &walk({instructions, map},
              from: &1,
              steps: 0,
              halt_when: fn str -> String.ends_with?(str, "Z") end
            )
          )
        end).()
    |> Enum.reduce(fn value, acc -> trunc(lcm(value, acc)) end)
  end

  defp walk({instructions, map}, from: location, steps: count, halt_when: condition) do
    if condition.(location) do
      count
    else
      # read first instruction , put it at the end
      [next_instruction | rest] = instructions
      new_instructions = rest ++ [next_instruction]

      # read current map location
      {_, go_left, go_right} = Enum.find(map, fn {node, _left, _right} -> node == location end)

      # set next location to L or 
      next_location =
        case next_instruction do
          "L" -> go_left
          "R" -> go_right
          _ -> raise "Where did you get that #{next_instruction} ?"
        end

      # recurse
      walk({new_instructions, map}, from: next_location, steps: count + 1, halt_when: condition)
    end
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
