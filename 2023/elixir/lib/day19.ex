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

  def part_two() do
    {workflows, _parts} =
      "input"
      |> read_file!()
      |> parse(part2: true)

    reverse_map =
      build_reverse_map(workflows, Map.new(), "A")

    constraints =
      count_ways_to_arrive_at(reverse_map, "A", %{
        "x" => 1..4000,
        "m" => 1..4000,
        "a" => 1..4000,
        "s" => 1..4000
      })

    constraints
    |> Enum.map(&calculate_possibilities/1)
    |> Enum.sum()
  end

  # pragma mark - part 2
  defp calculate_possibilities(constraints) do
    constraints
    |> Map.values()
    |> Enum.map(fn start..stop -> stop - start + 1 end)
    |> Enum.product()
  end

  defp count_ways_to_arrive_at(_map, "in", constraints), do: constraints

  defp count_ways_to_arrive_at(map, where, constraints) do
    paths = Map.get(map, where)

    # for each rule
    #   work backwards to determine what must be true to pass the workflow
    #   knowing the range is 1-4000 for the xmas values, determine how many inputs could pass
    #   work all the way backwards to the "in" workflow

    paths
    |> Enum.map(fn path -> {path, constraints} end)
    |> Enum.map(fn {path, the_constraints} ->
      [[comes_from: prev] | rest] = path
      must_be_true = List.last(rest)
      must_be_false = List.delete_at(rest, -1)

      updated_constraints =
        the_constraints
        |> adjust(true, must_be_true)

      even_more_updated =
        Enum.reduce(must_be_false, updated_constraints, fn rule, acc ->
          adjust(acc, false, rule)
        end)

      count_ways_to_arrive_at(map, prev, even_more_updated)
    end)
    |> List.flatten()
  end

  defp adjust(constraints, true, always_goes_to: _), do: constraints

  defp adjust(constraints, true, if: var, condition: {operator, value}, goes_to_workflow: _name) do
    start..stop = Map.get(constraints, var)

    new_range =
      case operator do
        ">" -> Enum.max([value + 1, start])..stop
        "<" -> start..Enum.min([value - 1, stop])
      end

    Map.put(constraints, var, new_range)
  end

  defp adjust(constraints, false, if: var, condition: {operator, value}, goes_to_workflow: _name) do
    start..stop = Map.get(constraints, var)

    new_range =
      case operator do
        ">" -> start..Enum.min([value, stop])
        "<" -> Enum.max([value, start])..stop
      end

    Map.put(constraints, var, new_range)
  end

  defp build_reverse_map(workflows, map, name) do
    # find all subset of rules that terminate in A
    {paths, new_names} = rules_terminating_in(workflows, name)

    # store those into the map
    updated = Map.put(map, name, paths)

    # find new entry points that are not yet keys of map, add them
    if length(new_names) == 0 do
      updated
    else
      Enum.reduce(new_names, updated, fn next_name, acc ->
        build_reverse_map(workflows, acc, next_name)
      end)
    end
  end

  # """
  #   a single rule would look like this
  #
  #     [if: variable, condition: operator, goes_to_workflow: destination, goes_to_workflow: "whatever"]
  #
  #   so for workflow named A we would return this
  #
  #   [
  #     {name, [[if: variable, operator: >], [if: variable, operator: >]]}
  #     {name, [[if: variable, operator: <], [if: variable, operator: >]]}
  #   ]
  # """

  defp rules_terminating_in(workflows, name) do
    terminals =
      Enum.map(workflows, fn {workflow_name, rules} ->
        if List.last(rules)[:always_goes_to] == name do
          {workflow_name, rules}
        else
          nil
        end
      end)
      |> Enum.reject(fn x -> x == nil end)

    intermediates = find_intermediate_rules(workflows, name)

    terminal_names = Enum.map(terminals, &elem(&1, 0))
    intermediate_names = Enum.map(intermediates, &elem(&1, 0))

    result =
      (terminals ++ intermediates)
      |> Enum.map(fn {workflow_name, rules} -> [[comes_from: workflow_name]] ++ rules end)

    {result, terminal_names ++ intermediate_names}
  end

  defp find_intermediate_rules(workflows, name) do
    workflows
    |> Enum.filter(fn {_workflow_name, rules} ->
      Enum.any?(rules, fn rule -> rule[:goes_to_workflow] == name end)
    end)
    |> Enum.flat_map(fn workflow -> extract_all_from(workflow, name) end)
  end

  defp extract_all_from({other_name, rules}, name) do
    0..(length(rules) - 1)
    |> Enum.filter(fn index -> Enum.at(rules, index)[:goes_to_workflow] == name end)
    |> Enum.map(fn index -> {other_name, Enum.take(rules, index + 1)} end)
  end

  # pragma mark - part 1
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

  defp parse(file, opts \\ []) do
    [top, bottom] = String.split(file, "\n\n")

    {
      top
      |> split_lines()
      |> Enum.map(&parse_workflow(&1, opts))
      |> Enum.reduce(Map.new(), fn {name, rules}, acc -> Map.put(acc, name, rules) end),
      bottom |> split_lines() |> Enum.map(&parse_part/1)
    }
  end

  defp parse_workflow(line, opts) do
    [name, rest] = String.split(line, "{")

    {name, parse_workflow_rules(String.replace(rest, "}", ""), opts)}
  end

  defp parse_workflow_rules(raw, opts) do
    list = String.split(raw, ",")

    list
    |> Enum.map(fn rule ->
      cond do
        String.contains?(rule, ">") -> parse_rule(rule, ">", opts)
        String.contains?(rule, "<") -> parse_rule(rule, "<", opts)
        true -> [always_goes_to: rule]
      end
    end)
  end

  defp parse_rule(rule, ">" = operator, opts) do
    [comparison, destination] = String.split(rule, ":")
    [variable, value_str] = String.split(comparison, operator)
    value = String.to_integer(value_str)

    condition =
      if Keyword.get(opts, :part2, false) do
        {operator, value}
      else
        fn x -> x > value end
      end

    [if: variable, condition: condition, goes_to_workflow: destination]
  end

  defp parse_rule(rule, "<" = operator, opts) do
    [comparison, destination] = String.split(rule, ":")
    [variable, value_str] = String.split(comparison, operator)
    value = String.to_integer(value_str)

    condition =
      if Keyword.get(opts, :part2, false) do
        {operator, value}
      else
        fn x -> x < value end
      end

    [if: variable, condition: condition, goes_to_workflow: destination]
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
