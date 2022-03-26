defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "we can brainstorm together" do
    # :egd.create(100, 100)

    # Draw Image (Identicon)

    # Save Image (Identicon)
  end

  test "can return the same list of ints for the same string" do
    assert Identicon.int_list_from_string("Billy") == Identicon.int_list_from_string("Billy")
    assert Enum.all?(Identicon.int_list_from_string("Billy"), &is_integer/1)

    #    :crypto.hash(:md5, "string") == :crypto.hash(:md5, "string")
    #  assert Q == :forgiven
  end

  test "can return a 5x5 list of lists" do
    list = 1..15 |> Enum.to_list()

    assert Identicon.to_grid(list) == [
             [1, 2, 3, 2, 1],
             [4, 5, 6, 5, 4],
             [7, 8, 9, 8, 7],
             [10, 11, 12, 11, 10],
             [13, 14, 15, 14, 13]
           ]
  end

  test "can create a 5x5 list from a int_list_from_string" do
  end

  test "can create a canvas for the identicon" do
    # each rectangle should be50*50 to equal to250x250
  end

  test "can generate start_end location of squares" do
    grid = Enum.to_list(1..5) |> Enum.map(fn _ -> Enum.to_list(1..5) end)

    assert [
             [
               {{0, 0}, {50, 50}},
               {{50, 0}, {100, 50}},
               {{100, 0}, {150, 50}},
               {{150, 0}, {200, 50}},
               {{200, 0}, {250, 50}}
             ]
           ] =
             Enum.with_index(grid)
             |> Enum.map(fn {row, row_index} ->
               row
               |> Enum.with_index()
               |> Enum.map(fn {column, column_index} ->
                 Identicon.generate_start_end(row_index, column_index)
               end)
             end)
  end

  test "can create a 1x5 row with :egd" do
    pid = :egd.create(250, 250)
    red = :egd.color(:red)
    row = [0, 1, 0, 1, 0]
    row_index = 0
    Identicon.write_row(pid, red, row, row_index)
    image_binary = :egd.render(pid)
    :egd.save(image_binary, "#{System.unique_integer()}.png")
  end

  test "can create a 5x5 image with :egd" do
    pid = :egd.create(250, 250)
    red = :egd.color(:red)
    blue = :egd.color(:blue)

    grid = [[0, 1, 0, 1, 0]]

    Enum.with_index(grid)
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {column, column_index} ->
        Identicon.generate_start_end(row_index, column_index)
      end)
    end)
    |> IO.inspect()

    # list2 =
    #   Enum.map(Enum.with_index(list1), fn {item, x} ->
    #     ## Enum.map(item, fn element ->
    #     {{x * 50, 0}, {x * 50 + 50, 50}, red}
    #     ## end)
    #   end)

    # list = [{{0, 0}, {50, 50}, red}, {{51, 0}, {100, 50}, blue}]

    # Enum.map(list2, fn item ->
    #   {p1, p2, color} = item
    #   assert :ok = :egd.filledRectangle(pid, p1, p2, color)
    # end)

    # image_binary = :egd.render(pid)
    # :egd.save(image_binary, "#{System.unique_integer()}.png")
  end
end

# Present from the peanut gallery:
# Color generator function
# color_generator_fun = fn number ->
#   Integer.to_string(number, 2)
#   |> String.pad_leading(8, "0")
#   |> String.codepoints()
#   |> Enum.chunk_every(2)
#   |> Enum.map(&List.to_string/1)
#   |> Enum.map(fn part -> String.pad_leading(part, 8, "0") end)
#   |> Enum.map(fn bin_value -> String.to_integer(bin_value, 2) end)
#   |> Enum.map(fn number -> number * div(255, 3) end)
#   |> List.to_tuple()
# end
