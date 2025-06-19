import Config

config :beam_flow,
  db_options: [
    create_if_missing: true,
    # 64 MB
    write_buffer_size: 64 * 1024 * 1024,
    max_open_files: 1000,
    compression: :snappy_compression
  ]

import_config "#{config_env()}.exs"
