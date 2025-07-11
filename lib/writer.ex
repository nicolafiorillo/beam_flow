defmodule Writer do
  @moduledoc """
  A GenServer that manages writing events to a RocksDB database.
  """
  require Logger

  use GenServer

  def start_link(opts \\ []) do
    db_path = Keyword.fetch!(opts, :db_path)
    db_options = Keyword.fetch!(opts, :db_options)

    if String.trim(db_path) == "", do: raise(ArgumentError, "db_path cannot be empty")

    GenServer.start_link(__MODULE__, %{db_path: db_path, db_options: db_options}, name: __MODULE__)
  end

  @global_position_key "e/$global_position"

  # Init

  @impl true
  def init(%{db_path: db_path, db_options: db_options}) do
    path = String.to_charlist(db_path)

    {:ok, db} = :rocksdb.open(path, db_options)

    case :rocksdb.get(db, @global_position_key, []) do
      {:ok, _global_position} ->
        # global_position already exists, do nothing
        :ok

      :not_found ->
        # global_position does not exist, initialize it
        :rocksdb.put(db, @global_position_key, <<0>>, [])

      {:error, reason} ->
        {:stop, {:error, reason}}
    end

    {:ok, %{db_path: db_path, db: db}}
  end

  # Api
  @spec put(String.t(), any()) :: any()
  def put(key, value), do: GenServer.call(__MODULE__, {:put, key, value})

  @spec get(String.t()) :: any()
  def get(key), do: GenServer.call(__MODULE__, {:get, key})

  @spec put_event(Event.t(), String.t()) :: any()
  def put_event(event, event_type), do: GenServer.call(__MODULE__, {:put_event, event, event_type})

  @spec show_database() :: any()
  def show_database(), do: GenServer.call(__MODULE__, :show_database)

  # Callbacks

  @impl true
  def handle_call({:put_event, %Event{} = event, event_type}, _from, state) do
    new_global_position = get_next_global_position(state.db)
    event = Map.put(event, "global_pos", new_global_position)

    :ok = :rocksdb.put(state.db, @global_position_key, :binary.encode_unsigned(new_global_position), [])

    key = get_global_key(new_global_position, event_type)
    value = Event.encode(event)
    Logger.debug("Putting event with key: #{inspect(key)} and value: #{inspect(value)}")

    case :rocksdb.put(state.db, key, value, []) do
      :ok ->
        {:reply, {:ok, key}, state}

      {:error, reason} ->
        Logger.error("Failed to put event: #{inspect(reason)}")
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call(:show_database, _from, state) do
    {:ok, it} = :rocksdb.iterator(state.db, [])

    it
    |> create_stream()
    |> Enum.each(fn {key, value} ->
      IO.puts("#{inspect(key)} -> {#{inspect(value)}}")
    end)

    :rocksdb.iterator_close(it)
    {:reply, :ok, state}
  end

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

  defp create_stream(iter) do
    Stream.unfold(:first, fn
      :iterator_closed ->
        nil

      position ->
        case :rocksdb.iterator_move(iter, position) do
          {:ok, key, value} ->
            {{key, value}, :next}

          {:error, :invalid_iterator} ->
            nil

          {:error, :iterator_closed} ->
            :iterator_closed
        end
    end)
  end

  defp get_next_global_position(db) do
    {:ok, global_position_binary} = :rocksdb.get(db, @global_position_key, [])

    global_position = :binary.decode_unsigned(global_position_binary)
    global_position + 1
  end

  @spec get_global_key(integer(), String.t()) :: String.t()
  defp get_global_key(global_pos, type), do: "e/#{global_pos}/#{type}"
end
