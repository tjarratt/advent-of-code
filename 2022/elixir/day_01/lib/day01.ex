defmodule Day01 do
  def part_one do
    "input"
    |> read_file()
    |> fn contents -> String.split(contents, "\n\n") end.()
    |> ( Enum.map(fn x -> String.split(x, "\n") end) )
    |> ( Enum.map(fn sublist -> Enum.reject(sublist, fn x -> x == "" end) end) )
    |> ( Enum.map(fn sublist -> Enum.map(sublist, &String.to_integer/1) end) )
    |> ( Enum.map &Enum.sum(&1) )
    |> Enum.max
  end

  def read_file(path) do
    case File.read(path) do
      {:ok, content}   -> content
      {:error, reason} ->
        IO.puts("Error reading file #{path} : #{reason}")
        :nil
    end
  end
end

IO.inspect Day01.part_one

