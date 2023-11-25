defmodule Day02 do
  def part_one do
    "input"
    |> read_input()
    |> String.trim_trailing()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> (fn program -> {0, program} end).()
    |> Intcode.calculate()
    |> elem(1)
    |> Enum.at(0)
  end

  def part_two do
    permutations()
    |> Enum.find(fn pair -> simulate(pair) == 19_690_720 end)
    |> (fn {noun, verb} -> 100 * noun + verb end).()
  end

  defp simulate({noun, verb}) do
    "input"
    |> read_input()
    |> String.trim_trailing()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> (fn program -> {0, program} end).()
    |> Intcode.calculate()
    |> elem(1)
    |> Enum.at(0)
  end

  defp permutations() do
    range = 0..99
    for x <- range, y <- range, do: {x, y}
  end

  defp read_input(filename) do
    path = Path.join(["resources", "02", filename])

    case File.read(path) do
      {:ok, contents} -> contents
      {:error, _} -> raise "no such file #{path}"
    end
  end
end
