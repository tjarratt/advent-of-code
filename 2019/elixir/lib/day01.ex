defmodule Day01 do
  def part_one do
    "input"
    |> read_file
    |> String.split("\n")
    |> Enum.filter(fn line -> String.length(line) > 0 end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&fuel_for/1)
    |> Enum.sum()
  end

  def part_two do
    "input"
    |> read_file
    |> String.split("\n")
    |> Enum.filter(fn line -> String.length(line) > 0 end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&recursive_fuel_for/1)
    |> Enum.sum()
  end

  def recursive_fuel_for(weight) do
    fuel = fuel_for(weight)

    cond do
      fuel <= 0 -> 0
      true -> fuel + recursive_fuel_for(fuel)
    end
  end

  def fuel_for(weight) do
    max(floor(weight / 3.0) - 2, 0)
  end

  defp read_file(path) do
    case File.read(Path.join(["resources", "01", path])) do
      {:ok, content} ->
        content

      {error, reason} ->
        IO.puts("Could not read file #{path}")
        nil
    end
  end
end
