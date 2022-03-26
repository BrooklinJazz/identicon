defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """
  require Integer

  @doc """
    Generate and identicon for a given string
    iex> Identicon.generate("brooklin")
    :ok
  """
  def generate(string) do
    string
    |> string_to_list()
    |> list_to_grid()
    |> grid_to_image()
    |> save_image("#{string}.png")
  end

  @doc """
  Generate int list for string using md5 algorithm
  iex> Identicon.string_to_list("brooklin")
  [105, 174, 27, 165, 161, 201, 147, 254, 140, 232, 157, 98, 255, 210, 39, 173]
  """
  def string_to_list(string) do
    :crypto.hash(:md5, string) |> :binary.bin_to_list()
  end

  @doc """
  Generate mirrored grid based on 15+ element list.
  iex> Identicon.list_to_grid(Enum.to_list(1..15))
  [[1, 2, 3, 2, 1], [4, 5, 6, 5, 4], [7, 8, 9, 8, 7], [10, 11, 12, 11, 10], [13, 14, 15, 14, 13]]
  iex> Identicon.list_to_grid(Enum.to_list(1..20))
  [[1, 2, 3, 2, 1], [4, 5, 6, 5, 4], [7, 8, 9, 8, 7], [10, 11, 12, 11, 10], [13, 14, 15, 14, 13]]
  """
  def list_to_grid(list) do
    list
    |> Enum.take(15)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] -> [a, b, c, b, a] end)
  end

  def grid_to_image(grid) do
    [[r, g, b | _] | _] = grid
    pid = :egd.create(250, 250)
    color = :egd.color({r, g, b})

    Enum.with_index(grid)
    |> Enum.each(fn {row, row_index} ->
      Enum.with_index(row)
      |> Enum.each(fn {item, column_index} ->
        if Integer.is_even(item) do
          {p1, p2} = points_at(column_index, row_index)

          :egd.filledRectangle(
            pid,
            p1,
            p2,
            color
          )
        end
      end)
    end)

    pid
  end

  @doc """
  iex> Identicon.points_at(0, 0)
  {{0, 0}, {50, 50}}

  iex> Identicon.points_at(1, 0)
  {{50, 0}, {100, 50}}
  """
  def points_at(column_index, row_index) do
    start_width = column_index * 50
    end_width = start_width + 50
    start_height = row_index * 50
    end_height = start_height + 50

    {{start_width, start_height}, {end_width, end_height}}
  end

  def save_image(pid, name) do
    :egd.render(pid) |> :egd.save(name)
  end
end
