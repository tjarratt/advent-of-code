defmodule Intcode do
  def calculate({ip, program}) do
    instruction = Enum.at(program, ip)

    {opcode, _parameter_modes} = parse(opcode: instruction)

    case opcode do
      1 -> {ip + 4, add(ip, program)} |> calculate()
      2 -> {ip + 4, multiply(ip, program)} |> calculate()
      3 -> {ip + 2, read_input(ip, program)} |> calculate()
      4 -> {ip + 2, write_output(ip, program)} |> calculate()
      99 -> {ip, program}
      _ -> raise "unexpected opcode #{opcode}"
    end
  end

  defp parse(opcode: instruction) do
    digits = instruction |> Integer.to_string()
    {modes, opcode_str} = String.split_at(digits, String.length(digits) - 2)

    parameter_modes =
      modes |> String.split("", trim: true) |> Enum.reverse() |> Enum.map(&String.to_integer/1)

    {
      String.to_integer(opcode_str),
      parameter_modes
    }
  end

  defp read_input(ip, program) do
    value =
      receive do
        {:input, input} -> input
      end

    addr = Enum.at(program, ip + 1)

    List.replace_at(program, addr, value)
  end

  defp write_output(ip, program) do
    addr = Enum.at(program, ip + 1)

    send(self(), {:write_output, Enum.at(program, addr)})

    program
  end

  defp add(ip, program) do
    a = Enum.at(program, ip + 1)
    b = Enum.at(program, ip + 2)
    addr = Enum.at(program, ip + 3)

    sum = Enum.at(program, a) + Enum.at(program, b)

    List.replace_at(program, addr, sum)
  end

  defp multiply(ip, program) do
    a = Enum.at(program, ip + 1)
    b = Enum.at(program, ip + 2)
    addr = Enum.at(program, ip + 3)

    product = Enum.at(program, a) * Enum.at(program, b)

    List.replace_at(program, addr, product)
  end
end
