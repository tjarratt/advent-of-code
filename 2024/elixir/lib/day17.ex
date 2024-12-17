defmodule Day17 do
  use AocTemplate

  def part_one() do
    {instructions, registers} =
      "input"
      |> read_file!()
      |> parse()

    run(instructions, registers, 0)
    |> Enum.map_join(",", &to_string/1)
  end

  def run(instructions, registers, ip, output \\ [])
  def run(instructions, _registers, ip, output) when ip >= length(instructions), do: output

  def run(instructions, registers, ip, output) do
    opcode = Enum.at(instructions, ip)
    operand = Enum.at(instructions, ip + 1)

    {new_registers, jump_by, maybe_output?} = perform_opcode(opcode, operand, registers)
    new_output = append_output(output, maybe_output?)

    new_ip =
      case jump_by do
        {:jump, where_to} -> where_to
        how_much -> ip + how_much
      end

    run(instructions, new_registers, new_ip, new_output)
  end

  defp append_output(output, nil), do: output
  defp append_output(output, new), do: output ++ [new]

  # adv
  defp perform_opcode(0, operand, registers) do
    numerator = Map.fetch!(registers, :a)
    denominator = Integer.pow(2, combo(operand, registers))

    {%{registers | a: div(numerator, denominator)}, 2, nil}
  end

  # bxl
  defp perform_opcode(1, operand, registers = %{b: b}) do
    result =
      Bitwise.bxor(operand, b)

    {%{registers | b: result}, 2, nil}
  end

  # bst
  defp perform_opcode(2, operand, registers) do
    {
      %{registers | b: operand |> combo(registers) |> Integer.mod(8)},
      2,
      nil
    }
  end

  # jnz
  defp perform_opcode(3, _operand, registers = %{a: 0}), do: {registers, 2, nil}

  defp perform_opcode(3, operand, registers = %{a: a}) when is_integer(a) and a > 0,
    do: {registers, {:jump, operand}, nil}

  # bxc
  defp perform_opcode(4, _operand, registers = %{b: b, c: c}) do
    {
      %{registers | b: Bitwise.bxor(b, c)},
      2,
      nil
    }
  end

  # out
  defp perform_opcode(5, operand, registers) do
    {registers, 2, combo(operand, registers) |> Integer.mod(8)}
  end

  # bdv
  defp perform_opcode(6, operand, registers = %{a: a}) do
    numerator = a
    denominator = Integer.pow(2, combo(operand, registers))

    {%{registers | b: div(numerator, denominator)}, 2, nil}
  end

  # cdv
  defp perform_opcode(7, operand, registers = %{a: a}) do
    numerator = a
    denominator = Integer.pow(2, combo(operand, registers))

    {
      %{registers | c: div(numerator, denominator)},
      2,
      nil
    }
  end

  defp combo(operand, _registers) when operand in [0, 1, 2, 3], do: operand
  defp combo(4, %{a: a_register}), do: a_register
  defp combo(5, %{b: b_register}), do: b_register
  defp combo(6, %{c: c_register}), do: c_register

  defp parse(contents) do
    [registers, program] = String.split(contents, "\n\n", trim: true)

    [a, b, c] =
      registers
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split(": ") |> List.last() |> String.to_integer()
      end)

    instructions =
      program
      |> String.split(": ", trim: true)
      |> then(&List.last(&1))
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {instructions, %{a: a, b: b, c: c}}
  end
end
