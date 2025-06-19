defmodule BeamFlowTest do
  use ExUnit.Case
  doctest BeamFlow

  test "greets the world" do
    assert BeamFlow.hello() == :world
  end
end
