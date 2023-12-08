defmodule Intcode do
  def calculate(program) do
    do_calculate({0, 0, program})
  end

  defp do_calculate({ip, output_written, program}) do
    instruction = Enum.at(program, ip)

    {opcode, modes} = parse(opcode: instruction)

    # TODO: another idea for how to do this
    # when we start calculation we are told who to write to
    # and then we always send there instead of send(self(), output)
    # this is less dynamic, but sets us up for success later on
    # when we need to connect intcode computers
    case opcode do
      1 -> {ip + 4, output_written, add(ip, program, modes)} |> do_calculate()
      2 -> {ip + 4, output_written, multiply(ip, program, modes)} |> do_calculate()
      3 -> {ip + 2, output_written, read_input(ip, program)} |> do_calculate()
      4 -> {ip + 2, output_written + 1, write_output(ip, program)} |> do_calculate()
      7 -> {ip + 4, output_written, check_less_than(ip, program, modes)} |> do_calculate()
      8 -> {ip + 4, output_written, check_equality(ip, program, modes)} |> do_calculate()
      99 -> {ip, output_written, program}
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

  defp mode_for_index(modes, index) do
    mode = Enum.at(modes, index - 1)

    if mode == nil do
      0
    else
      mode
    end
  end

  defp read_parameter(index, ip, program, modes) do
    case mode_for_index(modes, index) do
      0 ->
        addr = Enum.at(program, ip + index)
        Enum.at(program, addr)

      1 ->
        Enum.at(program, ip + index)
    end
  end

  defp add(ip, program, modes) do
    a = read_parameter(1, ip, program, modes)
    b = read_parameter(2, ip, program, modes)
    sum = a + b

    addr = Enum.at(program, ip + 3)

    List.replace_at(program, addr, sum)
  end

  defp multiply(ip, program, modes) do
    a = read_parameter(1, ip, program, modes)
    b = read_parameter(2, ip, program, modes)
    product = a * b

    addr = Enum.at(program, ip + 3)

    List.replace_at(program, addr, product)
  end
end
