defmodule Day11 do
  use AocTemplate

  def part_one() do
    {:ok, memoizer} = GenServer.start_link(__MODULE__.Memoizer, [])

    "input"
    |> read_file!()
    |> parse()
    |> blink(memoizer: memoizer, times: 25)
  end

  def part_two() do
    {:ok, memoizer} = GenServer.start_link(__MODULE__.Memoizer, [])

    "input"
    |> read_file!()
    |> parse()
    |> blink(memoizer: memoizer, times: 75)
  end

  defp blink(stones, memoizer: pid, times: how_many) do
    stones
    |> Enum.map(&blink_once(&1, memoizer: pid, times: how_many))
    |> Enum.sum()
  end

  defp blink_once(_stone, memoizer: _pid, times: 0), do: 1

  defp blink_once(stone, memoizer: pid, times: how_many) do
    if result = Day11.Memoizer.cached?(pid, stone, how_many) do
      result
    else
      new_stones = evolve(stone)

      cond do
        is_list(new_stones) and length(new_stones) == 2 ->
          [a, b] = new_stones

          a1 = blink_once(a, memoizer: pid, times: how_many - 1)
          b1 = blink_once(b, memoizer: pid, times: how_many - 1)

          Day11.Memoizer.cache(pid, stone, how_many, a1 + b1)
          a1 + b1

        true ->
          length = blink_once(new_stones, memoizer: pid, times: how_many - 1)

          Day11.Memoizer.cache(pid, stone, how_many, length)
          length
      end
    end
  end

  defp evolve(stone) do
    digits = Integer.digits(stone)

    cond do
      stone == 0 ->
        1

      length(digits) |> Integer.mod(2) == 0 ->
        {first, second} = Enum.split(digits, Integer.floor_div(length(digits), 2))
        [Integer.undigits(first), Integer.undigits(second)]

      true ->
        stone * 2024
    end
  end

  # # # parsing

  defp parse(file) do
    file
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # # # 

  defmodule Memoizer do
    use GenServer

    def init(_args) do
      {:ok, %{cache: %{}}}
    end

    def cached?(pid, stone, how_many) do
      GenServer.call(pid, {:cached?, stone, how_many})
    end

    def cache(pid, stone, how_many, result) do
      GenServer.call(pid, {:cache, stone, how_many, result})
    end

    def handle_call({:cache, stone, how_many, result}, _from, %{cache: cache} = state) do
      {:reply, nil, %{state | cache: cache |> Map.put({stone, how_many}, result)}}
    end

    def handle_call({:cached?, stone, how_many}, _from, %{cache: cache} = state) do
      {:reply, Map.get(cache, {stone, how_many}), state}
    end
  end
end
