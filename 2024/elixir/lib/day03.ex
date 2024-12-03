defmodule Day03 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> then(fn input -> Regex.scan(~r[(mul\(\d+,\d+\))], input, capture: :first) end)
    |> List.flatten()
    |> Enum.map(&multiply/1)
    |> Enum.sum()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> then(fn input ->
      Regex.scan(~r[(mul\(\d+,\d+\)|do\(\)|don't\(\))], input, capture: :first)
    end)
    |> List.flatten()
    |> Enum.reduce(%{mul_enabled: true, sum: 0}, &multiply_do_dont/2)
    |> Map.fetch!(:sum)
  end

  defp multiply(string) do
    [a, b] =
      Regex.scan(~r[mul\((\d+),(\d+)\)], string, capture: :all_but_first)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    a * b
  end

  def multiply_do_dont(string, state) do
    cond do
      state.mul_enabled and string =~ "mul" ->
        %{state | sum: state.sum + multiply(string)}

      state.mul_enabled == false and string =~ "mul" ->
        state

      string == "don't()" ->
        %{state | mul_enabled: false}

      string == "do()" ->
        %{state | mul_enabled: true}

      true ->
        raise "unknown operation #{string}"
    end
  end
end
