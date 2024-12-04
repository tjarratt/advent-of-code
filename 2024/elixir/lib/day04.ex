defmodule Day04 do
  use AocTemplate

  def part_one() do
    grid =
      "input"
      |> read_file!()
      |> to_coordinate_grid()

    grid
    |> find_possible_xmas_coords()
    |> Enum.reduce(0, fn coord, acc -> count_xmas(grid, coord, acc) end)
  end

  def part_two() do
    grid =
      "input"
      |> read_file!()
      |> to_coordinate_grid()

    grid
    |> find_all_a_coords()
    |> Enum.reduce(0, fn coord, acc -> count_cross_mas(grid, coord, acc) end)
  end

  # # # part one

  defp find_possible_xmas_coords(grid) do
    max_x = length(grid) - 1
    max_y = length(hd(grid)) - 1

    for x <- 0..max_x, y <- 0..max_y, value = safe_get_at(grid, x, y), value == "X" do
      %{value: value, coordinate: {x, y}}
    end
  end

  defp count_xmas(grid, %{coordinate: coordinates}, acc) do
    acc
    |> has_xmas?(grid, coordinates, :up)
    |> has_xmas?(grid, coordinates, :up_right)
    |> has_xmas?(grid, coordinates, :right)
    |> has_xmas?(grid, coordinates, :right_down)
    |> has_xmas?(grid, coordinates, :down)
    |> has_xmas?(grid, coordinates, :down_left)
    |> has_xmas?(grid, coordinates, :left)
    |> has_xmas?(grid, coordinates, :left_up)
  end

  defp has_xmas?(acc, grid, {x, y}, :up) do
    if safe_get_at(grid, x, y) == "X" and
         safe_get_at(grid, x, y - 1) == "M" and
         safe_get_at(grid, x, y - 2) == "A" and
         safe_get_at(grid, x, y - 3) == "S" do
      acc + 1
    else
      acc
    end
  end

  defp has_xmas?(acc, grid, {x, y}, :up_right) do
    if safe_get_at(grid, x, y) == "X" and
         safe_get_at(grid, x + 1, y - 1) == "M" and
         safe_get_at(grid, x + 2, y - 2) == "A" and
         safe_get_at(grid, x + 3, y - 3) == "S" do
      acc + 1
    else
      acc
    end
  end

  defp has_xmas?(acc, grid, {x, y}, :right) do
    if safe_get_at(grid, x, y) == "X" and
         safe_get_at(grid, x + 1, y) == "M" and
         safe_get_at(grid, x + 2, y) == "A" and
         safe_get_at(grid, x + 3, y) == "S" do
      acc + 1
    else
      acc
    end
  end

  defp has_xmas?(acc, grid, {x, y}, :right_down) do
    if safe_get_at(grid, x, y) == "X" and
         safe_get_at(grid, x + 1, y + 1) == "M" and
         safe_get_at(grid, x + 2, y + 2) == "A" and
         safe_get_at(grid, x + 3, y + 3) == "S" do
      acc + 1
    else
      acc
    end
  end

  defp has_xmas?(acc, grid, {x, y}, :down) do
    if safe_get_at(grid, x, y) == "X" and
         safe_get_at(grid, x, y + 1) == "M" and
         safe_get_at(grid, x, y + 2) == "A" and
         safe_get_at(grid, x, y + 3) == "S" do
      acc + 1
    else
      acc
    end
  end

  defp has_xmas?(acc, grid, {x, y}, :down_left) do
    if safe_get_at(grid, x, y) == "X" and
         safe_get_at(grid, x - 1, y + 1) == "M" and
         safe_get_at(grid, x - 2, y + 2) == "A" and
         safe_get_at(grid, x - 3, y + 3) == "S" do
      acc + 1
    else
      acc
    end
  end

  defp has_xmas?(acc, grid, {x, y}, :left) do
    if safe_get_at(grid, x, y) == "X" and
         safe_get_at(grid, x - 1, y) == "M" and
         safe_get_at(grid, x - 2, y) == "A" and
         safe_get_at(grid, x - 3, y) == "S" do
      acc + 1
    else
      acc
    end
  end

  defp has_xmas?(acc, grid, {x, y}, :left_up) do
    if safe_get_at(grid, x, y) == "X" and
         safe_get_at(grid, x - 1, y - 1) == "M" and
         safe_get_at(grid, x - 2, y - 2) == "A" and
         safe_get_at(grid, x - 3, y - 3) == "S" do
      acc + 1
    else
      acc
    end
  end

  # # # part two

  defp find_all_a_coords(grid) do
    max_x = length(grid) - 1
    max_y = length(hd(grid)) - 1

    for x <- 0..max_x, y <- 0..max_y, value = safe_get_at(grid, x, y), value == "A" do
      %{value: value, coordinate: {x, y}}
    end
  end

  defp count_cross_mas(grid, %{coordinate: {x, y}}, acc) do
    diag_1 =
      [
        safe_get_at(grid, x - 1, y + 1),
        safe_get_at(grid, x + 1, y - 1)
      ]
      |> Enum.sort()

    diag_2 =
      [
        safe_get_at(grid, x - 1, y - 1),
        safe_get_at(grid, x + 1, y + 1)
      ]
      |> Enum.sort()

    if safe_get_at(grid, x, y) == "A" and diag_1 == ["M", "S"] and diag_2 == ["M", "S"] do
      acc + 1
    else
      acc
    end
  end

  # # # common

  defp to_coordinate_grid(input) do
    input
    |> split_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp safe_get_at(grid, x, y) do
    cond do
      x < 0 or x >= length(grid) ->
        nil

      y < 0 or y >= length(hd(grid)) ->
        nil

      true ->
        grid |> Enum.at(y) |> Enum.at(x)
    end
  end
end
