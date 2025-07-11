defmodule BeamFlow do
  @moduledoc """
  Public API for the BeamFlow system.
  """

  @doc """
  Add an event.
  """
  @spec add_event(Event.t()) :: {:ok, String.t()} | {:error, term()}
  def add_event(event) do
    Writer.put_event(event, event.type)
  end
end
