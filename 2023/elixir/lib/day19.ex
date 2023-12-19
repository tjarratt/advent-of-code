defmodule Day19 do
  use AocTemplate

  def part_one() do
    {workflows, parts} =
      "input"
      |> read_file!()
      |> parse()

    parts
    |> Enum.filter(&acceptable?(&1, workflows))
    |> Enum.flat_map(&Tuple.to_list/1)
    |> Enum.sum()
  end

  defp acceptable?(part, workflows) do
    check_acceptable(part, workflows, name: "in")
  end

  defp check_acceptable(_part, _workflows, name: "A"), do: true
  defp check_acceptable(_part, _workflows, name: "R"), do: false

  defp check_acceptable(part, workflow, name: name) do
    rule = Enum.find(Map.get(workflow, name), &rule_matches?(&1, part))
    destination = destination_for(rule)

    check_acceptable(part, workflow, name: destination)
  end

  defp rule_matches?([always_goes_to: _name], _part), do: true

  defp rule_matches?([if: variable, condition: func, goes_to_workflow: _name], {x, m, a, s}) do
    to_check =
      case variable do
        "x" -> x
        "m" -> m
        "a" -> a
        "s" -> s
        _ -> raise "Where did you get that banana ?"
      end

    func.(to_check)
  end

  defp destination_for(always_goes_to: name), do: name
  defp destination_for(if: _if, condition: _operator, goes_to_workflow: name), do: name

  defp parse(file) do
    [top, bottom] = String.split(file, "\n\n")

    {
      top
      |> split_lines()
      |> Enum.map(&parse_workflow/1)
      |> Enum.reduce(Map.new(), fn {name, rules}, acc -> Map.put(acc, name, rules) end),
      bottom |> split_lines() |> Enum.map(&parse_part/1)
    }
  end

  defp parse_workflow(line) do
    [name, rest] = String.split(line, "{")

    {name, parse_workflow_rules(String.replace(rest, "}", ""))}
  end

  defp parse_workflow_rules(raw) do
    list = String.split(raw, ",")

    list
    |> Enum.map(fn rule ->
      cond do
        String.contains?(rule, ">") -> parse_rule(rule, ">")
        String.contains?(rule, "<") -> parse_rule(rule, "<")
        true -> [always_goes_to: rule]
      end
    end)
  end

  defp parse_rule(rule, ">" = operator) do
    [comparison, destination] = String.split(rule, ":")
    [variable, value_str] = String.split(comparison, operator)
    value = String.to_integer(value_str)

    operator = fn x -> x > value end

    [if: variable, condition: operator, goes_to_workflow: destination]
  end

  defp parse_rule(rule, "<" = operator) do
    [comparison, destination] = String.split(rule, ":")
    [variable, value_str] = String.split(comparison, operator)
    value = String.to_integer(value_str)

    operator = fn x -> x < value end

    [if: variable, condition: operator, goes_to_workflow: destination]
  end

  defp parse_part(line) do
    [["x", x], ["m", m], ["a", a], ["s", s]] =
      line
      |> String.replace(~r([{}]), "")
      |> String.split(",")
      |> Enum.map(&String.split(&1, "="))
      |> Enum.map(fn [label, value] -> [label, String.to_integer(value)] end)

    {x, m, a, s}
  end
end
