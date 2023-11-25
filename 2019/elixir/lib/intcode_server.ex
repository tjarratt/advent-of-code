defmodule IntCodeServer do
  # pragma mark - Public API
  def start_link() do
    Task.start_link(__MODULE__, :loop, [%{buffer: [], results: nil}])
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

  def read_output(pid) do
    send(pid, {:read_output, self()})

    receive do
      {:output, value} -> value
    end
  end

  # pragma mark - Private API
  def loop(%{buffer: buffer, results: _results} = state) do
    receive do
      {:execute, program} ->
        {_, memory} = Intcode.calculate({0, program})
        loop(%{state | results: memory})

      {:read_internal_memory, from} ->
        send(from, {:results, state.results})
        loop(state)

      {:provide_input, input} ->
        send(self(), {:input, input})
        loop(state)

      {:read_output, from} when buffer != [] ->
        [top | new_buffer] = buffer
        send(from, {:output, top})
        loop(%{state | buffer: new_buffer})

      {:write_output, value} ->
        new_buffer = buffer ++ [value]
        loop(%{state | buffer: new_buffer})
    end
  end
end
