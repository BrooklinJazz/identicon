defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @red :egd.color(:red)
  @blue :egd.color(:blue)

  # TODO Need to generate coloerrs

  @doc """
  iex> Identicon.generate_start_end(0, 0)
  {{0, 0}, {50, 50}}

  iex> Identicon.generate_start_end(0, 1)
  {{50, 0}, {100, 50}}
  """
  def generate_identicon(input_string) do
    pid = egd_create()
    hash = int_list_from_string(input_string)
    color = hd(hash) |> color_generator_fun()

    hash
    |> to_grid
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} -> write_row(pid, color, row, row_index) end)

    image_binary = :egd.render(pid)
    :egd.save(image_binary, "#{input_string}.png")
  end

  def generate_start_end(row, column) do
    square_size = 50
    start_height = row * square_size
    end_height = start_height + square_size
    start_width = column * square_size
    end_width = start_width + square_size

    {{start_width, start_height}, {end_width, end_height}}
  end

  # TODOlogic on whether to colora square or not
  def write_row(pid, color, row, row_index) do
    row
    |> Enum.with_index()
    |> Enum.each(fn {column, column_index} ->
      case is_even(column) do
       true -> {start_point, end_point} = Identicon.generate_start_end(row_index, column_index)
        :egd.filledRectangle(pid, start_point, end_point, color)

        false -> nil
      end
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
def color_generator_fun(number) do
Integer.to_string(number, 2)
|> String.pad_leading(8, "0")
|> String.codepoints()
|> Enum.chunk_every(2)
|> Enum.map(&List.to_string/1)
|> Enum.map(fn part -> String.pad_leading(part, 8, "0") end)
|> Enum.map(fn bin_value -> String.to_integer(bin_value, 2) end)
|> Enum.map(fn number -> number * div(255, 3) end)
|> List.to_tuple()
end

  defp egd_create(), do: :egd.create(250, 250)
  defp is_even(num), do: rem(num, 2) == 0
end
