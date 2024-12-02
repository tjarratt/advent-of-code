defmodule Day02 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(fn line -> line |> String.split(" ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.group_by(&safe?/1)
    |> Map.get(:safe)
    |> Enum.count()
  end

  def part_two() do
    %{safe: safe, unsafe: unsafe} =
      "input"
      |> read_file!()
      |> split_lines()
      |> Enum.map(fn line -> line |> String.split(" ") |> Enum.map(&String.to_integer/1) end)
      |> Enum.group_by(&safe?/1)

    Enum.count(safe) + count_safe_with_dampening(unsafe)
  end

  # # # part 1
  def safe?([head, tail]) do
    if abs(tail - head) in [1, 2, 3] do
      :safe
    else
      :unsafe
    end
  end

  def safe?([head, neck | tail] = reports) do
    cond do
      reports != Enum.sort(reports, :asc) and reports != Enum.sort(reports, :desc) ->
        :unsafe

      safe?([head, neck]) == :unsafe ->
        :unsafe

      # otherwise
      true ->
        safe?([neck | tail])
    end
  end

  def safe?(_), do: :safe

  # # # part 2

  defp count_safe_with_dampening(unsafe_reports) do
    unsafe_reports
    |> Enum.filter(fn report ->
      0..length(report)
      |> Enum.any?(fn index ->
        report
        |> List.delete_at(index)
        |> safe?()
        |> then(fn result -> result == :safe end)
      end)
    end)
    |> Enum.count()
  end
end
