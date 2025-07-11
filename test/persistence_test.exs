defmodule WriterTest do
  use ExUnit.Case

  import BeamFlow.TestHelper

  test "a write and its read" do
    key = a_key()

    Writer.put(key, "value")
    assert Writer.get(key) == {:ok, "value"}
  end

  test "an unknown key" do
    assert Writer.get(a_key()) == :not_found
  end

  test "events are inserted in the correct order" do
    1..100
    |> Enum.each(fn n ->
      event = an_event()
      assert BeamFlow.add_event(event) == {:ok, "e/#{n}/test_event"}
    end)
  end
end
