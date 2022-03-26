defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  describe "generate/1" do
    test "given brooklin generates brooklin.png" do
      assert :ok = Identicon.generate("brooklin")
      assert {:ok, _file} = File.read("brooklin.png")
      assert :ok = File.rm("brooklin.png")
    end
  end

  describe "grid_to_image/1" do
    test "given grid generates image" do
      grid = Identicon.list_to_grid(Enum.to_list(1..15))
      assert pid = Identicon.grid_to_image(grid)
      assert is_pid(pid)
    end
  end
end
