defmodule GetsafeTest do
  use ExUnit.Case
  doctest Getsafe

  test "greets the world" do
    assert Getsafe.hello() == :world
  end
end
