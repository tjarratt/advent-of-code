defmodule AocTemplate do
  defmacro __using__(_opts \\ []) do
    quote do
      def read_file!(name) do
        "Elixir.Day" <> day = Atom.to_string(__MODULE__)

        File.read!(Path.join(["resources", day, name])) |> String.trim()
      end

      def split_lines(content, opts \\ []) do
        delimiter = Keyword.get(opts, :on, "\n")

        content
        |> String.split(delimiter, trim: true)
        |> Enum.reject(fn line -> String.length(line) == 0 end)
      end
    end
  end
end
