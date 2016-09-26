defmodule Nerves.System.BR.Mixfile do
  use Mix.Project

@version Path.join(__DIR__, "VERSION")
         |> File.read!
         |> String.strip

  def project do
    [app: :nerves_system_br,
     version: @version,
     elixir: "~> 1.2",
     description: description,
     package: package,
     compilers: [:app]
    ]
  end

  defp description do
   """
   Nerves System BR - Buildroot based build platform for Nerves Systems
   """
  end

  defp package do
   [maintainers: ["Frank Hunleth", "Justin Schneck"],
    files: ["board", "package", "patches", "scripts", "Config.in", "create-build.sh", "external.mk", "LICENSE", "mix.exs", "nerves_env.exs",
    "nerves-env.sh", "nerves.exs", "nerves.mk", "README.md"],
    licenses: ["Apache 2.0", "GPLv2"],
    links: %{"Github" => "https://github.com/nerves-project/nerves_system_br"}]
  end

end
