defmodule Day22 do
  use AocTemplate

  alias __MODULE__.Solver

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> Enum.map(&Enum.reduce(1..2000, &1, fn _index, acc -> evolve(acc) end))
    |> Enum.sum()
  end

  def part_two() do
    {:ok, _pid} = Solver.start_link()

    "input"
    |> read_file!()
    |> parse()
    |> Enum.map(fn initial_secret ->
      Enum.reduce(1..2000, {initial_secret, []}, fn _index, {previous_secret, prices} ->
        secret = evolve(previous_secret)
        price = Integer.mod(secret, 10)
        {history, changes} = track_price_change(price, prices)

        Solver.track_price(initial_secret, price, changes)

        {secret, history}
      end)
    end)

    Solver.sequences()
    |> Enum.sort(fn {_seq1, a}, {_seq2, b} -> Enum.sum(a) > Enum.sum(b) end)
    |> hd()
    |> elem(1)
    |> Enum.sum()
  end

  defp track_price_change(price, history) when length(history) < 4 do
    result = history ++ [price]

    {result, []}
  end

  defp track_price_change(price, history) when length(history) == 4 do
    [_oldest | newer] = history

    result = newer ++ [price]

    changes =
      Enum.chunk_every(history ++ [price], 2, 1, :discard) |> Enum.map(fn [a, b] -> b - a end)

    {result, changes}
  end

  defp evolve(secret) do
    secret
    |> step(&Kernel.*(&1, 64))
    |> step(&Integer.floor_div(&1, 32))
    |> step(&Kernel.*(&1, 2048))
  end

  defp step(secret, operation) do
    secret |> operation.() |> mix(secret) |> prune()
  end

  defp mix(secret, given), do: Bitwise.bxor(secret, given)

  defp prune(secret), do: Integer.mod(secret, 16_777_216)

  defp parse(contents) do
    contents |> split_lines() |> Enum.map(&String.to_integer/1)
  end

  defmodule Solver do
    use GenServer

    def start_link(), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

    def init(_), do: {:ok, %{cache: Map.new(), monkeys: MapSet.new()}}

    def track_price(_index, _price, history) when length(history) < 4 do
      nil
    end

    def track_price(index, price, history) do
      GenServer.call(__MODULE__, {:track_price, index, price, history})
    end

    def sequences() do
      GenServer.call(__MODULE__, :sequences)
    end

    def handle_call(:sequences, _from, state = %{cache: cache}) do
      {:reply, cache, state}
    end

    def handle_call(
          {:track_price, index, price, history},
          _from,
          state = %{cache: cache, monkeys: monkey_cache}
        ) do
      new_state =
        if heard_from?(monkey_cache, index, history) do
          state
        else
          %{
            state
            | cache: Map.update(cache, history, [price], fn others -> [price | others] end),
              monkeys: MapSet.put(monkey_cache, {index, history})
          }
        end

      {:reply, nil, new_state}
    end

    defp heard_from?(cache, monkey, history) do
      MapSet.member?(cache, {monkey, history})
    end
  end
end
