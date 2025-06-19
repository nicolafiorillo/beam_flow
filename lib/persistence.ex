defmodule Persistence do
  @moduledoc """
  A GenServer template.
  """
  use GenServer

  def start_link(opts \\ []) do
    db_path = Keyword.fetch!(opts, :db_path)
    db_options = Keyword.fetch!(opts, :db_options)

    if String.trim(db_path) == "", do: raise(ArgumentError, "db_path cannot be empty")

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
  @spec put(String.t(), any()) :: any()
  def put(key, value), do: GenServer.call(__MODULE__, {:put, key, value})

  @spec get(String.t()) :: any()
  def get(key), do: GenServer.call(__MODULE__, {:get, key})

  # Callbacks

  @impl true
  def handle_call({:put, key, value}, _from, state) do
    case :rocksdb.put(state.db, key, value, []) do
      :ok ->
        {:reply, :ok, state}

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    res = :rocksdb.get(state.db, key, [])

    {:reply, res, state}
  end

  # Helpers
end
