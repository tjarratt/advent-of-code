defmodule Day03 do
  @symbols ~w[ ! @ # $ % ^ & * ( ) _ + = - / ]

  def part_one() do
    matrix =
      "input"
      |> read_file!()
      |> String.split("\n")
      |> Enum.reject(fn line -> String.length(line) == 0 end)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.with_index(&with_tuple/2)
      |> Enum.map(fn {idx, row} -> {idx, Enum.with_index(row, &with_tuple/2)} end)

    matrix
    |> extract_symbols()
    |> Enum.map(&find_nearby_numbers(&1, matrix))
    |> List.flatten()
    |> Enum.sum()
  end

  def part_two() do
    "not yet"
  end

  defp find_nearby_numbers(symbol, matrix) do
    symbol
    |> neighbors_of()
    |> Enum.filter(fn {y, x} -> is_digit?(element_at(matrix, y, x)) end)
    |> Enum.map(fn {y, x} -> {y, extract_number(matrix, y, x)} end)
    |> Enum.uniq()
    |> Enum.map(fn {_y, number} -> number end)
  end

  defp extract_number(matrix, y, x) do
    here = element_at(matrix, y, x)

    next = extract_number_forwards(matrix, y, x + 1)
    prev = extract_number_backwards(matrix, y, x - 1)

    [prev, here, next] |> List.flatten() |> Enum.join("") |> String.to_integer()
  end

  defp extract_number_forwards(matrix, y, x) do
    element = element_at(matrix, y, x)

    if !is_digit?(element) do
      []
    else
      [element, extract_number_forwards(matrix, y, x + 1)]
    end
  end

  defp extract_number_backwards(matrix, y, x) do
    element = element_at(matrix, y, x)

    if !is_digit?(element) do
      []
    else
      [extract_number_backwards(matrix, y, x - 1), element]
    end
  end

  defp is_digit?(nil), do: false

  defp is_digit?(element) do
    String.match?(element, ~r([0-9]))
  end

  defp element_at(matrix, y, x) do
    with {^y, row} <- Enum.find(matrix, fn {y_idx, _row} -> y_idx == y end),
         {^x, element} <- Enum.find(row, fn {x_idx, _ele} -> x_idx == x end) do
      element
    end
  end

  defp neighbors_of({y, x, _symbol}) do
    [
      # top row
      {y - 1, x - 1},
      {y - 1, x},
      {y - 1, x + 1},
      # middle row
      {y, x - 1},
      {y, x + 1},
      # bottom row
      {y + 1, x - 1},
      {y + 1, x},
      {y + 1, x + 1}
    ]
  end

  defp extract_symbols(matrix) do
    matrix
    |> Enum.map(fn {y_idx, row} ->
      {y_idx, Enum.filter(row, fn {_idx, char} -> char in @symbols end)}
    end)
    |> Enum.filter(fn {_idx, row} -> length(row) > 0 end)
    |> Enum.map(fn {y_idx, row} -> Enum.map(row, fn {x_idx, ele} -> {y_idx, x_idx, ele} end) end)
    |> List.flatten()
  end

  defp with_tuple(element, index), do: {index, element}

  defp read_file!(name) do
    File.read!(Path.join(["resources", "03", name]))
  end
end
