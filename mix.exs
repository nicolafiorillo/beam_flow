defmodule BeamFlow.MixProject do
  use Mix.Project

  def project do
    [
      app: :beam_flow,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :observer, :wx],
      mod: {BeamFlow.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}

      # RocksDB requires:
      #   sudo apt install build-essential cmake libsnappy-dev zlib1g-dev libbz2-dev libgflags-dev liblz4-dev libzstd-dev
      {:rocksdb, "~> 1.9"},
      {:elixir_uuid, "~> 1.2"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
