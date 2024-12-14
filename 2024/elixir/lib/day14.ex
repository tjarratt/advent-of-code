defmodule Day14 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(&parse_line/1)
    |> Enum.map(&tick(&1, 100))
    |> Enum.map(&elem(&1, 0))
    |> Enum.reject(&on_middle_lines?/1)
    |> Enum.group_by(&quadrant/1)
    |> Map.values()
    |> Enum.map(&length/1)
    |> Enum.product()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(&parse_line/1)
    |> check_for_tree()
  end

  defp check_for_tree(robots) do
    Enum.reduce(1..10_000, robots, fn seconds_elapsed, robots ->
      new_robots = robots |> Enum.map(&tick(&1, 1))

      if Integer.mod(seconds_elapsed, 103) == 12, do: pp(new_robots, seconds_elapsed)

      new_robots
    end)
  end

  @max_width 101
  @max_height 103

  defp pp(robots, seconds_elapsed) do
    robot_map = robots |> Enum.into(%{})

    for y <- 0..@max_height do
      for x <- 0..@max_width do
        if Map.has_key?(robot_map, [x, y]) do
          IO.write("*")
        else
          IO.write(".")
        end
      end

      IO.puts("")
    end

    IO.puts("")
    IO.puts("... after #{seconds_elapsed} seconds")
    IO.gets("")

    robots
  end

  defp tick(robot_info, 0), do: robot_info

  defp tick({[px, py], [vx, vy] = velocity}, seconds) do
    new_position = [px + vx, py + vy] |> wrap()

    tick({new_position, velocity}, seconds - 1)
  end

  defp wrap([px, py]) do
    [Integer.mod(px, @max_width), Integer.mod(py, @max_height)]
  end

  defp on_middle_lines?([px, py]) do
    py == div(@max_height - 1, 2) or px == div(@max_width - 1, 2)
  end

  # ---------
  # | 0 | 1 | 
  # | ----- | 
  # | 2 | 3 | 
  # ---------
  defp quadrant(position) do
    cond do
      top_left?(position) -> 0
      top_right?(position) -> 1
      bottom_left?(position) -> 2
      bottom_right?(position) -> 3
    end
  end

  defp top_left?([px, py]) do
    py < div(@max_height - 1, 2) and px < div(@max_width - 1, 2)
  end

  defp top_right?([px, py]) do
    py < div(@max_height - 1, 2) and px > div(@max_width - 1, 2)
  end

  defp bottom_left?([px, py]) do
    py > div(@max_height - 1, 2) and px < div(@max_width - 1, 2)
  end

  defp bottom_right?([px, py]) do
    py > div(@max_height - 1, 2) and px > div(@max_width - 1, 2)
  end

  defp parse_line(line) do
    [position, velocity] =
      Regex.scan(~r[(-?\d+),(-?\d+)], line, capture: :first)
      |> List.flatten()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn points -> Enum.map(points, &String.to_integer/1) end)

    {position, velocity}
  end
end
