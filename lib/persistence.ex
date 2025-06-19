defmodule Persistence do
  @moduledoc """
  A GenServer template.
  """
  use GenServer

  def start_link(opts \\ []) do
    db_path = Keyword.fetch!(opts, :db_path)
    db_options = Keyword.fetch!(opts, :db_options)

    if String.trim(db_path) == "" do
      raise(ArgumentError, "db_path cannot be empty")
    end

    GenServer.start_link(__MODULE__, %{db_path: db_path, db_options: db_options}, name: __MODULE__)
  end

  # Init

  @impl true
  def init(%{db_path: db_path, db_options: db_options}) do
    path = String.to_charlist(db_path)

    {:ok, db} = :rocksdb.open(path, db_options)
    {:ok, %{db_path: db_path, db: db}}
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
