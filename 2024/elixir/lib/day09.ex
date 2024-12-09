defmodule Day09 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> defrag()
    |> checksum()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> parse(:part_two)
    |> defrag(:part_two)
    |> checksum(:part_two)
  end

  # # # part 1

  defp defrag({blocks, blocks_reversed}) do
    {defragged, defragged_reversed} = defrag_once({blocks, blocks_reversed})

    if blocks == defragged do
      blocks
    else
      defrag({defragged, defragged_reversed})
    end
  end

  defp defrag_once({blocks, blocks_reversed}) do
    free_index = Enum.find_index(blocks, &(&1 == :free))

    {block, index_to_defrag} =
      Enum.find(blocks_reversed, fn {block, _index} -> block != :free end)

    if free_index > index_to_defrag do
      {blocks, blocks_reversed}
    else
      new_blocks =
        blocks
        |> List.replace_at(free_index, block)
        |> List.replace_at(index_to_defrag, :free)

      new_blocks_reversed =
        blocks_reversed
        |> List.replace_at(length(blocks) - 1 - free_index, {block, free_index})
        |> List.replace_at(length(blocks) - 1 - index_to_defrag, {:free, index_to_defrag})

      {new_blocks, new_blocks_reversed}
    end
  end

  # # # part 2

  defp defrag(blocks, :part_two), do: do_defrag(blocks, length(blocks) - 1)

  defp do_defrag(blocks, next_to_defrag) when next_to_defrag < 0, do: blocks

  defp do_defrag(blocks, defrag_index) do
    {defrag_me, next_defrag_index} = find_next(:to_defrag, blocks, defrag_index)

    free_result =
      find_next(:free, blocks, at_least: defrag_me.size, not_before: next_defrag_index)

    blocks =
      case free_result do
        nil ->
          blocks

        {free_block, next_free_index} ->
          cond do
            free_block.size > defrag_me.size ->
              new_free_block = %{id: :free, size: free_block.size - defrag_me.size}

              blocks
              |> List.replace_at(next_free_index, defrag_me)
              |> List.replace_at(next_defrag_index, %{id: :free, size: defrag_me.size})
              |> List.insert_at(next_free_index + 1, new_free_block)

            free_block.size == defrag_me.size ->
              blocks
              |> List.replace_at(next_free_index, defrag_me)
              |> List.replace_at(next_defrag_index, free_block)
          end
      end

    do_defrag(blocks, next_defrag_index - 1)
  end

  defp find_next(:free, blocks, at_least: minimum_size, not_before: upper_bound) do
    blocks
    |> Enum.with_index()
    |> Enum.find(fn {block, index} ->
      block.id == :free and block.size >= minimum_size and index < upper_bound
    end)
  end

  defp find_next(:to_defrag, blocks, before_index) do
    blocks
    |> Enum.with_index()
    |> Enum.reverse()
    |> Enum.find(fn {block, index} -> index <= before_index and block.id != :free end)
  end

  # # # checksum

  defp checksum(blocks) do
    blocks
    |> Enum.with_index()
    |> Enum.reduce(0, fn {block, index}, acc ->
      if block == :free do
        acc
      else
        acc + block * index
      end
    end)
  end

  defp checksum(blocks, :part_two) do
    blocks
    |> Enum.map(fn block -> List.duplicate(block.id, block.size) end)
    |> List.flatten()
    |> checksum()
  end

  # # # parsing

  defp parse(file) do
    blocks =
      file
      |> String.trim_trailing()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.with_index()
      |> Enum.map(&parse_chunk/1)
      |> List.flatten()

    reversed_blocks =
      blocks
      |> Enum.with_index()
      |> Enum.reverse()

    {blocks, reversed_blocks}
  end

  defp parse(file, :part_two) do
    file
    |> String.trim_trailing()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.map(&parse_chunk(&1, :as_file))
    |> List.flatten()
  end

  defp parse_chunk({[file_size, free_space], index}) do
    List.duplicate(index, file_size) ++
      List.duplicate(:free, free_space)
  end

  defp parse_chunk({[file_size], index}) do
    List.duplicate(index, file_size)
  end

  defp parse_chunk({[file_size, free_size], index}, :as_file) do
    [
      %{id: index, size: file_size},
      %{id: :free, size: free_size}
    ]
  end

  defp parse_chunk({[file_size], index}, :as_file) do
    [
      %{id: index, size: file_size}
    ]
  end
end
