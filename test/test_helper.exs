ExUnit.start()

defmodule BeamFlow.TestHelper do
  @moduledoc false

  def a_key() do
    random_key = :crypto.strong_rand_bytes(64)
    Base.encode64(random_key)
  end
end
