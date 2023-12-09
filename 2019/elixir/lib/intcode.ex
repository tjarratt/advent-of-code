defmodule Intcode do
  def calculate(program) do
    do_calculate({0, 0, program})
  end

  defp do_calculate({ip, output_written, program} = state) do
    instruction = Enum.at(program, ip)

    {opcode, modes} = parse(opcode: instruction)

    # another idea for how to handle writing output
    # when we start calculation we are told who to write to
    # and then we always send there instead of send(self(), output)
    # this is less dynamic, but sets us up for success later on
    # when we need to connect intcode computers

    case opcode do
      1 ->
        add(state, modes) |> do_calculate()

      2 ->
        multiply(state, modes) |> do_calculate()

      3 ->
        read_input(state) |> do_calculate()

      4 ->
        write_output(state) |> do_calculate()

      6 ->
        jump_if_false(state, modes) |> do_calculate()

      7 ->
        check_less_than(state, modes) |> do_calculate()

      8 ->
        check_equality(state, modes) |> do_calculate()

      99 ->
        {ip, output_written, program}

      _ ->
        raise "unexpected opcode #{opcode}"
    end
  end

  # pragma mark - opcode handlers

  defp read_input({ip, output_written, program}) do
    value =
      receive do
        {:input, input} -> input
      end

    addr = Enum.at(program, ip + 1)

    {ip + 2, output_written, List.replace_at(program, addr, value)}
  end

  defp write_output({ip, output_written, program}) do
    addr = Enum.at(program, ip + 1)

    send(self(), {:write_output, Enum.at(program, addr)})

    {ip + 2, output_written + 1, program}
  end

  defp add({ip, output_written, program}, modes) do
    a = read_parameter(1, ip, program, modes)
    b = read_parameter(2, ip, program, modes)
    sum = a + b

    addr = Enum.at(program, ip + 3)

    {ip + 4, output_written, List.replace_at(program, addr, sum)}
  end

  defp multiply({ip, output_written, program}, modes) do
    a = read_parameter(1, ip, program, modes)
    b = read_parameter(2, ip, program, modes)
    product = a * b

    addr = Enum.at(program, ip + 3)

    {ip + 4, output_written, List.replace_at(program, addr, product)}
  end

  defp check_equality({ip, output_written, program}, modes) do
    a = read_parameter(1, ip, program, modes)
    b = read_parameter(2, ip, program, modes)

    result =
      if a == b do
        1
      else
        0
      end

    addr = Enum.at(program, ip + 3)

    {ip + 4, output_written, List.replace_at(program, addr, result)}
  end

  defp check_less_than({ip, output_written, program}, modes) do
    a = read_parameter(1, ip, program, modes)
    b = read_parameter(2, ip, program, modes)

    result =
      if a < b do
        1
      else
        0
      end

    addr = Enum.at(program, ip + 3)

    {ip + 4, output_written, List.replace_at(program, addr, result)}
  end

  defp jump_if_false({ip, output_written, program}, modes) do
    a = read_parameter(1, ip, program, modes)
    addr = read_parameter(2, ip, program, modes)

    new_pointer =
      if a == 0 do
        addr
      else
        ip + 2
      end

    {new_pointer, output_written, program}
  end

  # pragma mark - functions to read next instruction information

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

  defp read_parameter(index, ip, program, modes) do
    case mode_for_index(modes, index) do
      0 ->
        addr = Enum.at(program, ip + index)
        Enum.at(program, addr)

      1 ->
        Enum.at(program, ip + index)
    end
  end

  defp mode_for_index(modes, index) do
    mode = Enum.at(modes, index - 1)

    if mode == nil do
      0
    else
      mode
    end
  end
end
