ExUnit.start()

defmodule BeamFlow.TestHelper do
  @moduledoc false

  def a_key(), do: UUID.uuid4(:hex)

  def an_event() do
    Event.new(
      a_key(),
      "test_event",
      %{data: "test_data"}
    )
  end
end
