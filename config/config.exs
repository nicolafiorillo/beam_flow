import Config

config :beam_flow,
  db_options: [
    create_if_missing: true,
    # 64 MB
    write_buffer_size: 64 * 1024 * 1024,
    max_open_files: 1000,
    compression: :snappy_compression
  ]

config :logger, :default_formatter,
  format: "[$level] $message $metadata\n",
  metadata: [:error_code, :file]

import_config "#{config_env()}.exs"
