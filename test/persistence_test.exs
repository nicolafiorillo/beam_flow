defmodule PersistenceTest do
  use ExUnit.Case
  doctest BeamFlow

  import BeamFlow.TestHelper

  test "a write and its read" do
    key = a_key()

    Persistence.put(key, "value")
    assert Persistence.get(key) == {:ok, "value"}
  end

  test "an unknown key" do
    assert Persistence.get(a_key()) == :not_found
  end
end
