defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  iex> Identicon.generate_start_end(0, 0)
  {{0, 0}, {50, 50}}

  iex> Identicon.generate_start_end(0, 1)
  {{50, 0}, {100, 50}}
  """
  def generate_start_end(row, column) do
    square_size = 50
    start_height = row * square_size
    end_height = start_height + square_size
    start_width = column * square_size
    end_width = start_width + square_size

    {{start_width, start_height}, {end_width, end_height}}
  end

  def write_row(pid, color, row, row_index) do
    row
    |> Enum.with_index()
    |> Enum.each(fn {_column, column_index} ->
      {start_point, end_point} = Identicon.generate_start_end(row_index, column_index)
      :egd.filledRectangle(pid, start_point, end_point, color)
    end)
  end

  def int_list_from_string(input_string) when is_binary(input_string) do
    # Choice of algorithm important?
    :crypto.hash(:md5, input_string) |> :binary.bin_to_list()

    # What output do we want?
  end

  def to_grid(list) do
    Enum.chunk_every(list, 3, 3, :discard)
    |> Enum.map(fn [a, b, c] -> [a, b, c, b, a] end)
  end
end
