defmodule IntCodeServer do
  # pragma mark - Public API
  def start_link() do
    Task.start_link(__MODULE__, :loop, [
      %{buffer: [], results: nil, output_read: 0, output_written: nil}
    ])
  end

  def provide_input(pid, value) do
    send(pid, {:provide_input, value})

    pid
  end

  def execute(pid, program) do
    send(pid, {:execute, program})

    pid
  end

  def read_internal_memory(pid) do
    send(pid, {:read_internal_memory, self()})

    receive do
      {:results, memory} -> memory
    end
  end

  def has_more_output?(pid) do
    send(pid, {:has_more_output?, self()})

    receive do
      {:output_remaining?, value} -> value
    end
  end

  def read_next_output(pid) do
    send(pid, {:read_output, self()})

    receive do
      {:output, value} -> value
    end
  end

  # pragma mark - Private API
  def loop(%{buffer: buffer, results: _, output_written: _, output_read: output_read} = state) do
    receive do
      {:execute, program} ->
        {_, output_count, memory} = Intcode.calculate(program)
        loop(%{state | results: memory, output_written: output_count})

      {:read_internal_memory, from} ->
        send(from, {:results, state.results})
        loop(state)

      {:provide_input, input} ->
        send(self(), {:input, input})
        loop(state)

      {:read_output, from} when buffer != [] ->
        [top | new_buffer] = buffer
        send(from, {:output, top})
        new_count = output_read + 1
        loop(%{state | buffer: new_buffer, output_read: new_count})

      {:write_output, value} ->
        new_buffer = buffer ++ [value]
        loop(%{state | buffer: new_buffer})

      {:has_more_output?, from} ->
        result = state.output_read < state.output_written

        send(from, {:output_remaining?, result})
        loop(state)
    end
  end
end
