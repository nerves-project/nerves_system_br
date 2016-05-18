defmodule Nerves.System.BR do
  alias Nerves.Env

  def bootstrap(%{path: path}) do
    path
    |> Path.join("nerves_env.exs")
    |> Code.require_file
  end

  def build_paths(pkg) do
    system_br = Env.package(:nerves_system_br)
    [{:platform, system_br.path, "/nerves/env/platform"},
     {:package, pkg.path, "/nerves/env/#{pkg.app}"}]
  end

  def stream() do
    Nerves.System.BR.Stream
  end
end
