defmodule AocTemplate do
  defmacro __using__(_opts \\ []) do
    quote do
      import AocTemplate

      def read_file!(name) do
        "Elixir.Day" <> day = Atom.to_string(__MODULE__)

        File.read!(Path.join(["resources", day, name])) |> String.trim()
      end
    end
  end

  def split_lines(content, opts \\ []) do
    delimiter = Keyword.get(opts, :on, "\n")

    content
    |> String.split(delimiter, trim: true)
    |> Enum.reject(fn line -> String.length(line) == 0 end)
  end

  def parse_to_grid(input) do
    input
    |> split_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.with_index()
    |> Enum.map(fn {row, index} -> {Enum.with_index(row), index} end)
    |> Enum.map(fn {row, y} -> Enum.map(row, fn {value, x} -> {{y, x}, value} end) end)
    |> List.flatten()
    |> Enum.into(Map.new())
  end
end
