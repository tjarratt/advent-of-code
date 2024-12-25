defmodule Day24 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> simulate()
    |> read_binary_number()
  end

  defp read_binary_number(states) do
    states
    |> Enum.filter(fn {key, _value} -> String.starts_with?(key, "z") end)
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Enum.with_index()
    |> Enum.reduce(0, fn {state, index}, acc ->
      if state == "0", do: acc, else: acc + Integer.pow(2, index)
    end)
  end

  defp simulate({state, _gates, []}), do: state

  defp simulate({state, gates, waiting_for}) do
    new_state =
      Enum.reduce(state, state, fn {left, left_value}, acc ->
        simulate_flowing_current(
          acc,
          state,
          left_value,
          Enum.filter(gates, &(Map.get(&1, :left) == left))
        )
      end)

    new_zed_values = new_state |> Map.keys() |> Enum.filter(&String.starts_with?(&1, "z"))

    new_waiting_for = waiting_for -- new_zed_values

    simulate({new_state, gates, new_waiting_for})
  end

  defp simulate_flowing_current(new_state, state, left_value, connections) do
    Enum.reduce(connections, new_state, &simulate_one_flowing_current(&2, state, left_value, &1))
  end

  defp simulate_one_flowing_current(acc, state, left_value, %{
         op: op,
         right: right,
         outputs_to: output
       }) do
    right_value = Map.get(state, right)

    if right_value != nil do
      new_value = simulate_gate(op, left_value, right_value)

      Map.put(acc, output, new_value)
    else
      acc
    end
  end

  defp simulate_gate("AND", left, right) do
    if left == "1" and right == "1", do: "1", else: "0"
  end

  defp simulate_gate("OR", left, right) do
    if left == "1" or right == "1", do: "1", else: "0"
  end

  defp simulate_gate("XOR", left, right) do
    cond do
      left == "1" and right == "0" -> "1"
      left == "0" and right == "1" -> "1"
      true -> "0"
    end
  end

  defp parse(contents) do
    [states, gates] = split_lines(contents, on: "\n\n")

    initial_state =
      states
      |> split_lines()
      |> Enum.map(&String.split(&1, ": "))
      |> Enum.reduce(%{}, fn [gate, state], acc ->
        Map.put(acc, gate, state)
      end)

    {gates, waiting_for} =
      gates
      |> split_lines()
      |> Enum.reduce({[], []}, fn line, {gates_acc, waiting_for_acc} ->
        [gate_connection, output] = String.split(line, " -> ")
        [left, op, right] = String.split(gate_connection, " ")

        gate = %{left: left, op: op, right: right, outputs_to: output}

        zed_gates =
          if String.starts_with?(output, "z") do
            [output | waiting_for_acc]
          else
            waiting_for_acc
          end

        {[gate | gates_acc], zed_gates}
      end)

    {initial_state, gates, waiting_for}
  end
end
