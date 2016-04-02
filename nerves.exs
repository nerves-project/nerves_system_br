use Mix.Config

config :nerves_system_br, :nerves_env,
  type:  :system_build_platform,
  package_files: [
    "board",
    "buildroot-*",
    "configs",
    "package",
    "patches",
    "scripts",
    "Config.in",
    "create-build.sh",
    "mix.exs"
  ]
