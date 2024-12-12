defmodule Day12 do
  use AocTemplate

  def part_one() do
    {:ok, _} = Day12.Memoizer.start_link()

    grid =
      "input"
      |> read_file!()
      |> parse_to_grid()

    grid
    |> Map.values()
    |> Enum.uniq()
    |> Enum.map(&identify_plots_of_plant(&1, Map.to_list(grid), grid))
    |> Enum.map(&calculate_price/1)
    |> Enum.sum()
  end

  defp calculate_price(plots) do
    plots
    |> Enum.map(fn plot ->
      plot
      |> Enum.map(&elem(&1, 2))
      |> Enum.sum()
      |> then(fn perimeter ->
        area = length(plot)
        perimeter * area
      end)
    end)
    |> Enum.sum()
  end

  defp identify_plots_of_plant(plant, locations, grid) do
    # for each crop, walk outwards from each point
    # building up each plot, taking care not to re-consider a plot more than once
    # and then take the unique collection of plots
    plots =
      locations
      |> Enum.filter(fn {_coords, planted} -> plant == planted end)
      |> Enum.map(fn location ->
        neighbors =
          location
          |> identify_neighbors(grid)

        result =
          neighbors
          |> List.flatten()
          |> Enum.uniq()
          |> MapSet.new()
          |> MapSet.to_list()

        result
      end)

    plots
    |> Enum.uniq()
    |> Enum.reject(&(&1 == []))
  end

  defp identify_neighbors({{y, x}, plant} = location, grid) do
    if Day12.Memoizer.cached?(location) do
      []
    else
      neighbors =
        [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
        |> Enum.map(fn {dy, dx} ->
          coords = {y + dy, x + dx}
          {coords, Map.get(grid, coords)}
        end)
        |> Enum.reject(&(elem(&1, 1) != plant))

      new_neighbors = Enum.reject(neighbors, &Day12.Memoizer.cached?(&1))
      Day12.Memoizer.cache(location)

      rest =
        new_neighbors
        |> Enum.map(&identify_neighbors(&1, grid))

      [{{y, x}, plant, 4 - length(neighbors)}] ++ rest
    end
  end

  defmodule Memoizer do
    use GenServer

    def start_link() do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_args) do
      {:ok, %{cache: MapSet.new()}}
    end

    def cached?(location) do
      GenServer.call(__MODULE__, {:cached?, location})
    end

    def cache(location) do
      GenServer.call(__MODULE__, {:cache, location})
    end

    def handle_call({:cache, location}, _from, %{cache: cache} = state) do
      {:reply, nil, %{state | cache: cache |> MapSet.put(location)}}
    end

    def handle_call({:cached?, location}, _from, %{cache: cache} = state) do
      {:reply, MapSet.member?(cache, location), state}
    end
  end
end
