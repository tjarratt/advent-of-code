defmodule Day05 do
  def part_one() do
    {:ok, pid} = IntCodeServer.start_link()

    program =
      "input"
      |> read_input()
      |> String.trim_trailing()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    diagnostic_code =
      pid
      |> IntCodeServer.provide_input(1)
      |> IntCodeServer.execute(program)
      |> dump_all_output()
      |> Enum.reverse()
      |> hd()

    IO.puts("the diagnostic code is #{diagnostic_code}")
  end

  defp dump_all_output(pid, result \\ []) do
    if !IntCodeServer.has_more_output?(pid) do
      result
    else
      output = IntCodeServer.read_next_output(pid)
      dump_all_output(pid, result ++ [output])
    end
  end

  defp read_input(file_name) do
    File.read!(Path.join(["resources", "05", file_name]))
  end
end
