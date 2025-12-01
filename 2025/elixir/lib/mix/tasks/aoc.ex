defmodule Mix.Tasks.Aoc do
  use Mix.Task

  def run([day]) do
    module_name = "Elixir.Day#{String.pad_leading(day, 2, "0")}" |> String.to_atom()

    case Code.ensure_loaded(module_name) do
      {:module, module} ->
        run_solutions(module)

      {:error, _reason} ->
        no_such_day_error(day)
    end
  end

  def run(otherwise), do: no_such_day_error(otherwise)

  def run() do
    IO.puts("Usage: mix aoc <day>")
    IO.puts("eg:    mix aoc 11")
    exit(1)
  end

  defp run_solutions(module) do
    has_part_one = function_exported?(module, :part_one, 0)
    has_part_two = function_exported?(module, :part_two, 0)

    case {has_part_one, has_part_two} do
      {true, true} ->
        IO.puts(module.part_one())
        IO.puts(module.part_two())

      {true, false} ->
        IO.puts(module.part_one())

      _ ->
        IO.puts("No solution functions found on module #{module}")
    end
  end

  defp no_such_day_error(input) do
    IO.puts("Sorry, there is no solution for day #{inspect(input)}")
    exit(1)
  end
end
