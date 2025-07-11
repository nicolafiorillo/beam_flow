defmodule Event do
  @moduledoc """
  A module representing an event in the BeamFlow system.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          global_pos: integer(),
          type: String.t(),
          payload: map(),
          timestamp: DateTime.t()
        }

  defstruct [:id, :global_pos, :type, :payload, :timestamp]

  @doc """
  Creates a new event with the given attributes.
  """
  @spec new(String.t(), String.t(), map()) :: Event.t()
  def new(id, type, payload) do
    %__MODULE__{
      id: id,
      type: type,
      payload: payload,
      timestamp: DateTime.utc_now()
    }
  end

  def encode(%__MODULE__{} = event), do: :erlang.term_to_binary(event)
  def decode(binary) when is_binary(binary), do: :erlang.binary_to_term(binary)
end
