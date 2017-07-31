use Mix.Config

version =
  Path.join(__DIR__, "VERSION")
  |> File.read!
  |> String.trim

config :nerves_system_br, :nerves_env,
  type: :system_platform,
  version: version
