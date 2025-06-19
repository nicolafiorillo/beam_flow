defmodule Persistence do
  @moduledoc """
  A GenServer template.
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Init

  @impl true
  def init(_opts) do
    path = ~c"/tmp/rocksdb.fold.test"

    {:ok, db} = :rocksdb.open(path, create_if_missing: true)

    state = %{counter: 0, db: db}
    {:ok, state}
  end

  # Api
  def sync_inc(value) do
    GenServer.call(__MODULE__, {:sync_inc, [value]})
  end

  # Callbacks

  @impl true
  def handle_call({:sync_inc, [value]}, _from, state) do
    resp = state.counter + value
    {:reply, resp, %{state | counter: resp}}
  end

  # Helpers
end
