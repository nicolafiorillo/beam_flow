defmodule BeamFlow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: BeamFlow.Worker.start_link(arg)
      # {BeamFlow.Worker, arg}
      {Writer,
       [
         db_path: Application.get_env(:beam_flow, :db_path) || "",
         db_options: Application.get_env(:beam_flow, :db_options) || []
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BeamFlow.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
