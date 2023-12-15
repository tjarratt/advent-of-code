defmodule Day15 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.flat_map(&String.split(&1, ","))
    |> Enum.map(&hash_step/1)
    |> Enum.sum()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.flat_map(&String.split(&1, ","))
    |> Enum.map(&parse_step(&1))
    |> Enum.reduce(Map.new(), &initialization_sequence/2)
    |> Map.to_list()
    |> Enum.flat_map(&box_to_lenses/1)
    |> Enum.map(&focusing_power/1)
    |> Enum.sum()
  end

  defp focusing_power({focal_length, lens_index, box_index}) do
    (1 + box_index) * (1 + lens_index) * focal_length
  end

  defp box_to_lenses({box_id, lenses}) do
    lenses
    |> Enum.with_index()
    |> Enum.map(fn {{_label, focal_length}, index} ->
      {focal_length, index, box_id}
    end)
  end

  defp initialization_sequence({:store, label_to_store, focal_length}, map) do
    box_id = hash_step(label_to_store)

    box = Map.get(map, box_id, [])
    labels = Enum.map(box, fn {label, _} -> label end)

    if label_to_store in labels do
      updated =
        Enum.map(box, fn {label, _focal_length} = lens ->
          if label == label_to_store do
            {label_to_store, focal_length}
          else
            lens
          end
        end)

      Map.put(map, box_id, updated)
    else
      Map.put(map, box_id, box ++ [{label_to_store, focal_length}])
    end
  end

  defp initialization_sequence({:pop, label_to_delete}, map) do
    box_id = hash_step(label_to_delete)

    box =
      map
      |> Map.get(box_id, [])
      |> Enum.map(fn {label, _focal_length} = lens ->
        if label == label_to_delete do
          nil
        else
          lens
        end
      end)
      |> List.delete(nil)

    Map.put(map, box_id, box)
  end

  defp hash_step(step) do
    step
    |> String.split("", trim: true)
    |> Enum.reduce(0, fn char, acc ->
      char
      |> String.to_charlist()
      |> hd()
      |> (fn x -> acc + x end).()
      |> (fn x -> x * 17 end).()
      |> rem(256)
    end)
  end

  defp parse_step(line) do
    if String.match?(line, ~r([a-z]+=[0-9]+)) do
      [label, lens] = String.split(line, "=")
      {:store, label, String.to_integer(lens)}
    else
      [label, ""] = String.split(line, "-")
      {:pop, label}
    end
  end
end
