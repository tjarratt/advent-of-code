defmodule Day15 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> simulate()
    |> Enum.to_list()
    |> Enum.filter(&(elem(&1, 1) == "O"))
    |> Enum.map(&gps_coordinates/1)
    |> Enum.sum()
  end

  defp gps_coordinates({{y, x}, _}) do
    100 * y + x
  end

  defp simulate({map, _robot, []}), do: map

  defp simulate({map, robot, [instruction | rest]}) do
    {new_robot, impacted_boxes} =
      case move(robot, instruction, map) do
        nil -> {robot, []}
        otherwise -> otherwise
      end

    map =
      impacted_boxes
      |> Enum.reverse()
      |> Enum.reduce(map, fn {old_box, new_box}, acc ->
        acc |> Map.delete(old_box) |> Map.put(new_box, "O")
      end)

    simulate({map, new_robot, rest})
  end

  @max_width 51
  @max_height 71

  defp move({y, x}, instruction, map) do
    {position, direction, to_check} =
      case instruction do
        "^" -> {{y - 1, x}, :up, %{x: x, y: Enum.to_list((y - 1)..1//-1)}}
        ">" -> {{y, x + 1}, :right, %{y: y, x: Enum.to_list((x + 1)..@max_width)}}
        "v" -> {{y + 1, x}, :down, %{x: x, y: Enum.to_list((y + 1)..@max_height)}}
        "<" -> {{y, x - 1}, :left, %{y: y, x: Enum.to_list((x - 1)..1//-1)}}
      end

    {boxes, new_boxes} = boxes_in_direction(map, direction, to_check)

    if any_walls_blocking?(map, [position | new_boxes]) do
      nil
    else
      {position, Enum.zip(boxes, new_boxes)}
    end
  end

  defp boxes_in_direction(map, :up, %{x: x, y: y}) when is_list(y) do
    boxes =
      Enum.map(y, &{&1, x})
      |> Enum.map(&{&1, Map.get(map, &1)})
      |> Enum.take_while(&(elem(&1, 1) == "O"))
      |> Enum.map(&elem(&1, 0))

    new_boxes = Enum.map(boxes, fn {y, x} -> {y - 1, x} end)

    {boxes, new_boxes}
  end

  defp boxes_in_direction(map, :down, %{x: x, y: y}) when is_list(y) do
    boxes =
      Enum.map(y, &{&1, x})
      |> Enum.map(&{&1, Map.get(map, &1)})
      |> Enum.take_while(&(elem(&1, 1) == "O"))
      |> Enum.map(&elem(&1, 0))

    new_boxes = Enum.map(boxes, fn {y, x} -> {y + 1, x} end)
    {boxes, new_boxes}
  end

  defp boxes_in_direction(map, :left, %{x: x, y: y}) when is_list(x) do
    boxes =
      Enum.map(x, &{y, &1})
      |> Enum.map(&{&1, Map.get(map, &1)})
      |> Enum.take_while(&(elem(&1, 1) == "O"))
      |> Enum.map(&elem(&1, 0))

    new_boxes = Enum.map(boxes, fn {y, x} -> {y, x - 1} end)

    {boxes, new_boxes}
  end

  defp boxes_in_direction(map, :right, %{x: x, y: y}) when is_list(x) do
    boxes =
      Enum.map(x, &{y, &1})
      |> Enum.map(&{&1, Map.get(map, &1)})
      |> Enum.take_while(&(elem(&1, 1) == "O"))
      |> Enum.map(&elem(&1, 0))

    new_boxes = Enum.map(boxes, fn {y, x} -> {y, x + 1} end)

    {boxes, new_boxes}
  end

  defp any_walls_blocking?(map, locations) do
    Enum.any?(locations, fn coords -> Map.get(map, coords) == "#" end)
  end

  defp parse(input) do
    [map, instructions] = String.split(input, "\n\n", trim: true)
    instructions = instructions |> String.replace("\n", "") |> String.split("", trim: true)

    {warehouse, robot} = parse_warehouse(map)

    {warehouse, robot, instructions}
  end

  defp parse_warehouse(map) do
    %{"@" => [robot], "." => free_space, "#" => walls, "O" => boxes} =
      map
      |> parse_to_grid()
      |> Map.to_list()
      |> Enum.group_by(&elem(&1, 1))

    {Enum.into(walls ++ free_space ++ boxes, %{}), elem(robot, 0)}
  end
end
