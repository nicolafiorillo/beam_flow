import Config

config :beam_flow,
  db_path: "/tmp/rocksdb.fold.test",
  db_options: [
    in_memory: true
  ]
