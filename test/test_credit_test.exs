defmodule TestCreditTest do
  use ExUnit.Case
  doctest TestCredit

  test "greets the world" do
    assert TestCredit.hello() == :world
  end
end
