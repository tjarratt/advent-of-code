defmodule AocTemplate do
  defmacro __using__(_opts \\ []) do
    quote do
      def read_file!(name) do
        "Elixir.Day" <> day = Atom.to_string(__MODULE__)

        File.read!(Path.join(["resources", day, name]))
      end
    end
  end
end
