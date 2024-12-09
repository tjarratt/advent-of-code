defmodule Day09 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> parse()
    |> defrag()
    |> checksum()
  end

  defp defrag({blocks, blocks_reversed}) do
    {defragged, defragged_reversed} = defrag_once(blocks, blocks_reversed)

    if blocks == defragged do
      blocks
    else
      defrag({defragged, defragged_reversed})
    end
  end

  defp defrag_once(blocks, blocks_reversed) do
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

  defp parse_chunk({[file_size, free_space], index}) do
    List.duplicate(index, file_size) ++
      List.duplicate(:free, free_space)
  end

  defp parse_chunk({[file_size], index}) do
    List.duplicate(index, file_size)
  end
end
