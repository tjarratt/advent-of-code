defmodule Day19 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> solve()
  end

  def part_two() do
    {:ok, _pid} = Day19.Memoizer.start_link()

    "input"
    |> read_file!()
    |> parse()
    |> solve_part_two()
  end

  defp solve_part_two({available, desired}) do
    desired
    |> Enum.map(fn towel_pattern ->
      Task.async(fn -> count_solutions(towel_pattern, available) end)
    end)
    |> Task.await_many()
    |> Enum.sum()
  end

  # # # part 2

  defp count_solutions("", _patterns), do: 1

  defp count_solutions(desired, patterns) do
    if cached = Day19.Memoizer.cached?(desired) do
      cached
    else
      result =
        patterns
        |> Enum.map(fn pattern ->
          if String.starts_with?(desired, pattern) do
            ^pattern <> remaining = desired

            count_solutions(remaining, patterns)
          else
            0
          end
        end)
        |> Enum.sum()

      Day19.Memoizer.cache(desired, result)

      result
    end
  end

  # # # part 1

  defp solve({available, desired}) do
    desired
    |> Enum.filter(&solveable?(&1, available))
    |> length()
  end

  defp solveable?("", _patterns), do: true
  defp solveable?(_desired, []), do: false

  defp solveable?(desired, patterns) do
    Enum.any?(patterns, fn pattern ->
      if String.starts_with?(desired, pattern) do
        ^pattern <> remaining = desired

        solveable?(remaining, patterns)
      else
        false
      end
    end)
  end

  defp parse(input) do
    [available, desired] = String.split(input, "\n\n", trim: true)

    {
      split_lines(available, on: ", "),
      split_lines(desired)
    }
  end

  defmodule Memoizer do
    use GenServer

    def start_link() do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_args), do: {:ok, %{cache: Map.new()}}

    def cached?(string), do: GenServer.call(__MODULE__, {:cached?, string})
    def cache(string, count), do: GenServer.call(__MODULE__, {:set_cache, string, count})

    def handle_call({:set_cache, string, count}, _from, state = %{cache: cache}) do
      {:reply, nil, %{state | cache: cache |> Map.put(string, count)}}
    end

    def handle_call({:cached?, string}, _from, state = %{cache: cache}) do
      {:reply, Map.get(cache, string), state}
    end
  end
end
