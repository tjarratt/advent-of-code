defmodule Day16 do
  use AocTemplate

  def part_one() do
    result =
      "input"
      |> read_file!()
      |> parse_matrix()
      |> trace_path([], [{0, 0, :right}])
      |> Enum.map(&ignoring_direction/1)
      |> MapSet.new()
      |> MapSet.size()

    # need to include the first location as being visited too
    result + 1
  end

  defp ignoring_direction({y, x, _dir}), do: {y, x}

  defp trace_path(_matrix, visited, []), do: visited

  defp trace_path(matrix, visited, lightbeams) do
    next_lightbeams = Enum.flat_map(lightbeams, &follow_the_light(matrix, &1))

    newly_visited =
      next_lightbeams
      |> Enum.map(&next_square(matrix, &1))
      |> Enum.reject(fn x -> x == nil end)

    trace_path(matrix, visited ++ newly_visited, newly_visited -- visited)
  end

  # decide which direction the beam changes when it enters this square
  defp follow_the_light(matrix, {y, x, direction} = beam) do
    {^y, ^x, element} = matrix |> row_at(y) |> Enum.at(x)

    case element do
      "." -> [{y, x, direction}]
      "|" -> follow_splitter(element, beam)
      "-" -> follow_splitter(element, beam)
      "/" -> follow_mirror(element, beam)
      "\\" -> follow_mirror(element, beam)
    end
  end

  defp follow_splitter("|", {y, x, direction}) when direction in [:left, :right] do
    [
      {y, x, :up},
      {y, x, :down}
    ]
  end

  defp follow_splitter("-", {y, x, direction}) when direction in [:up, :down] do
    [
      {y, x, :left},
      {y, x, :right}
    ]
  end

  defp follow_splitter(_splitter, beam), do: [beam]

  defp follow_mirror("/", {y, x, :up}), do: [{y, x, :right}]
  defp follow_mirror("/", {y, x, :down}), do: [{y, x, :left}]
  defp follow_mirror("/", {y, x, :left}), do: [{y, x, :down}]
  defp follow_mirror("/", {y, x, :right}), do: [{y, x, :up}]

  defp follow_mirror("\\", {y, x, :up}), do: [{y, x, :left}]
  defp follow_mirror("\\", {y, x, :down}), do: [{y, x, :right}]
  defp follow_mirror("\\", {y, x, :left}), do: [{y, x, :up}]
  defp follow_mirror("\\", {y, x, :right}), do: [{y, x, :down}]

  defp next_square(matrix, {y, x, direction}) do
    {y_prime, x_prime} =
      case direction do
        :left -> {y, x - 1}
        :right -> {y, x + 1}
        :up -> {y - 1, x}
        :down -> {y + 1, x}
      end

    if y_prime < 0 or y_prime >= length(matrix) or
         x_prime < 0 or x_prime >= length(hd(matrix)) do
      nil
    else
      {y_prime, x_prime, direction}
    end
  end

  # pragma mark - matrix helpers

  defp row_at(matrix, index) do
    Enum.at(matrix, index)
  end

  defp parse_matrix(file) do
    file
    |> split_lines()
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.with_index(&with_tuple/2)
    |> Enum.map(fn {y_index, row} ->
      Enum.with_index(row, fn ele, x_index -> {y_index, x_index, ele} end)
    end)
  end

  defp with_tuple(element, index), do: {index, element}
end
