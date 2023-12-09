defmodule IntCodeTest do
  use ExUnit.Case, async: true

  describe "intcode computer" do
    test "can perform addition" do
      {_, _, result} = Intcode.calculate([1, 0, 0, 0, 99])

      assert result == [2, 0, 0, 0, 99]
    end

    test "can perform multplication" do
      {_, _, result} = Intcode.calculate([2, 3, 0, 3, 99])

      assert result == [2, 3, 0, 6, 99]
    end
  end

  describe "running an intcode server" do
    test "opcode 3 reads input and writes it to the specified address" do
      program = [3, 1, 99]

      {:ok, pid} = IntCodeServer.start_link()

      internal_memory =
        pid
        |> IntCodeServer.provide_input(666)
        |> IntCodeServer.execute(program)
        |> IntCodeServer.read_internal_memory()

      assert Enum.at(internal_memory, 1) == 666
    end

    test "opcode 4 outputs the value of its parameter" do
      program = [4, 3, 99, 666]

      {:ok, pid} = IntCodeServer.start_link()

      output =
        pid
        |> IntCodeServer.execute(program)
        |> IntCodeServer.read_next_output()

      assert output == 666
    end

    test "arguments can be read in immediate mode" do
      program = [1002, 4, 3, 4, 33]

      {:ok, pid} = IntCodeServer.start_link()

      internal_memory =
        pid
        |> IntCodeServer.execute(program)
        |> IntCodeServer.read_internal_memory()

      assert internal_memory == [1002, 4, 3, 4, 99]
    end

    test "handles negative numbers with aplomb" do
      program = [1101, 100, -1, 4, 0]

      {:ok, pid} = IntCodeServer.start_link()

      internal_memory =
        pid
        |> IntCodeServer.execute(program)
        |> IntCodeServer.read_internal_memory()

      assert internal_memory == [1101, 100, -1, 4, 99]
    end

    test "checks equality of input using position mode" do
      program = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]

      {:ok, pid} = IntCodeServer.start_link()

      truthy =
        pid
        |> IntCodeServer.provide_input(8)
        |> IntCodeServer.execute(program)
        |> IntCodeServer.read_next_output()

      assert truthy == 1

      falsy =
        pid
        |> IntCodeServer.provide_input(7)
        |> IntCodeServer.execute(program)
        |> IntCodeServer.read_next_output()

      assert falsy == 0
    end

    test "checks whether a given number is less than another" do
      program = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]

      {:ok, pid} = IntCodeServer.start_link()

      truthy =
        pid
        |> IntCodeServer.provide_input(7)
        |> IntCodeServer.execute(program)
        |> IntCodeServer.read_next_output()

      assert truthy == 1

      falsy =
        pid
        |> IntCodeServer.provide_input(9)
        |> IntCodeServer.execute(program)
        |> IntCodeServer.read_next_output()

      assert falsy == 0
    end
  end
end
