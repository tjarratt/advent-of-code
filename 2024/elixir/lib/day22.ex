defmodule Day22 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> Enum.map(&Enum.reduce(1..2000, &1, fn _index, acc -> evolve(acc) end))
    |> Enum.sum()
  end

  defp evolve(secret) do
    secret
    |> step(&Kernel.*(&1, 64))
    |> step(&Integer.floor_div(&1, 32))
    |> step(&Kernel.*(&1, 2048))
  end

  defp step(secret, operation) do
    secret |> operation.() |> mix(secret) |> prune()
  end

  defp mix(secret, given), do: Bitwise.bxor(secret, given)

  defp prune(secret), do: Integer.mod(secret, 16_777_216)

  defp parse(contents) do
    contents |> split_lines() |> Enum.map(&String.to_integer/1)
  end
end
