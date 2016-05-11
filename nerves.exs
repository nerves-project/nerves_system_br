use Mix.Config

config :nerves_system_br, :nerves_env,
  type: :system_platform,
  package_files: [
    "board",
    "configs",
    "package",
    "patches",
    "scripts",
    "Config.in",
    "create-build.sh",
    "nerves_evv.sh",
    "mix.exs"
  ]
