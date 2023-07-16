defmodule GroupSum do
  def read_and_find_largest_group(file_path) do
    file_path
    |> read_file()
    |> split_groups()
    |> parse_integers()
    |> calculate_sums()
    |> find_largest_sum()
    |> IO.inspect
  end

  def read_file(file_path) do
    case File.read(file_path) do
      {:ok, content} -> content
      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}")
        ""
    end
  end

  def split_groups(content) do
    String.split(content, "\n\n")
  end

  def parse_integers(groups) do
    groups
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map((&String.to_integer/1))
  end

  def calculate_sums(groups) do
    Enum.map(groups, &Enum.sum(&1))
  end

  def find_largest_sum(sums) do
    Enum.max(sums)
  end
end

GroupSum.read_and_find_largest_group("test-input")

