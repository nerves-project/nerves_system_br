
defmodule System.Env do
  @path "PATH"
  @ld_library_path "LD_LIBRARY_PATH"

  def path_add(p) do
    System.put_env(@path, "#{path}:#{p}")
  end

  def ld_library_path_add(p) do
    System.put_env(@ld_library_path, "#{ld_library_path}:#{p}")
  end

  def path do
    System.get_env(@path)
  end

  def ld_library_path do
    System.get_env(@ld_library_path)
  end
end

system_path = System.get_env("NERVES_SYSTEM") || raise "You must set NERVES_SYSTEM to the system dir prior to requiring this file"

{_toolchain_path, crosscompile} =
  if File.dir?(Path.join(system_path, "host")) do
    toolchain_path =
      system_path
      |> Path.join("host")

    crosscompile =
      toolchain_path
      |> Path.join("usr/bin/*gcc")
      |> Path.wildcard
      |> List.first
      |> String.replace_suffix("-gcc", "")


    System.put_env("PKG_CONFIG", Path.join(toolchain_path, "usr/bin/pkg-config"))
    System.put_env("PKG_CONFIG_SYSROOT_DIR", "/")
    System.put_env("PKG_CONFIG_LIBDIR", Path.join(toolchain_path, "usr/lib/pkgconfig"))
    System.put_env("PERLLIB", Path.join(toolchain_path, "usr/lib/perl"))

    Path.join(toolchain_path, "usr/bin")
    |> System.Env.path_add

    Path.join(toolchain_path, "usr/sbin")
    |> System.Env.path_add

    Path.join(toolchain_path, "bin")
    |> System.Env.path_add

    Path.join(toolchain_path, "usr/lib")
    |> System.Env.ld_library_path_add

    {toolchain_path, crosscompile}
  else
    # Not a BR Local Provider build
    toolchain_path = System.get_env("NERVES_TOOLCHAIN")
    # Find the crosscompilers
    crosscompile =
      toolchain_path
      |> Path.join("bin/*gcc")
      |> Path.wildcard
      |> List.first
      |> String.replace_suffix("-gcc", "")
    # Add toolchain bin to path
    Path.join(toolchain_path, "bin")
    |> System.Env.path_add

    {toolchain_path, crosscompile}
  end

if crosscompile == "" do
  raise "Cannot find a cross compiler"
end

sdk_sysroot = Path.join(system_path, "staging")

System.put_env("NERVES_SDK_IMAGES", Path.join(system_path, "images"))
System.put_env("NERVES_SDK_SYSROOT", sdk_sysroot)

unless File.dir?(Path.join(system_path, "staging")) do
  raise "ERROR: It looks like the system hasn't been built!"
end

System.put_env("CROSSCOMPILE", "")

erts_dir =
  Path.join(sdk_sysroot, "usr/lib/erlang/erts-*")
  |> Path.wildcard
  |> List.first
System.put_env("ERTS_DIR", erts_dir)

erl_interface_dir =
  Path.join(sdk_sysroot, "/usr/lib/erlang/lib/erl_interface-*")
  |> Path.wildcard
  |> List.first
System.put_env("ERL_INTERFACE_DIR", erl_interface_dir)

rebar_plt_dir =
  Path.join(sdk_sysroot, "/usr/lib/erlang")
System.put_env("REBAR_PLT_DIR", rebar_plt_dir)

System.put_env("CC", "#{crosscompile}-gcc")
System.put_env("CXX", "#{crosscompile}-g++")
System.put_env("CFLAGS", "-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os")
System.put_env("CXXFLAGS", "-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os")
System.put_env("LDFLAGS", "")
System.put_env("STRIP", "#{crosscompile}-strip")
System.put_env("ERL_CFLAGS", "-I#{erts_dir}/include -I#{erl_interface_dir}/include")
System.put_env("ERL_LDFLAGS", "-L#{erts_dir}/lib -L#{erl_interface_dir}/lib -lerts -lerl_interface -lei")
System.put_env("REBAR_TARGET_ARCH", Path.basename(crosscompile))

# Rebar naming
System.put_env("ERL_EI_LIBDIR", Path.join(erl_interface_dir, "lib"))
System.put_env("ERL_EI_INCLUDE_DIR", Path.join(erl_interface_dir, "include"))

host_erl_major_ver = :erlang.system_info(:otp_release) |> to_string
[target_erl_major_version | _] =
  sdk_sysroot
  |> Path.join("/usr/lib/erlang/releases/*/OTP_VERSION")
  |> Path.wildcard
  |> List.first
  |> File.read!
  |> String.strip
  |> String.split(".")

# Check to see if the system major version of ERL and the target major version match
if host_erl_major_ver != target_erl_major_version do
  raise Nerves.Env.Exception, message: """
  Major version mismatch between host and target Erlang/OTP versions
    Host version: #{host_erl_major_ver}
    Target version: #{target_erl_major_version}

  This will likely cause Erlang code compiled for the target to fail in
  unexpected ways. Install an Erlang OTP release that matches the target
  version before continuing.
  """
end
