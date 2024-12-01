defmodule AocSupportTest do
  use ExUnit.Case
  doctest AocSupport

  test "greets the world" do
    assert AocSupport.hello() == :world
  end
end
