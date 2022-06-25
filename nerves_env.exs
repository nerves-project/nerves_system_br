defmodule System.Env do
  @path "PATH"
  @ld_library_path "LD_LIBRARY_PATH"

  def path_add(p) do
    System.put_env(@path, "#{p}:#{path()}")
  end

  def ld_library_path_add(p) do
    System.put_env(@ld_library_path, "#{p}:#{ld_library_path()}")
  end

  def path do
    System.get_env(@path)
  end

  def ld_library_path do
    System.get_env(@ld_library_path)
  end
end

defmodule Utils do
  def crosscompile(gcc_path, system_path) do
    gcc =
      gcc_path
      |> Path.join("*gcc")
      |> Path.wildcard()
      |> List.first()

    gcc ||
      Mix.raise("""
      gcc should have been found in \"#{gcc_path}\", but wasn't.
      \"#{system_path}\" is partial or corrupt and may need to be deleted.
      """)

    String.replace_suffix(gcc, "-gcc", "")
  end
end

system_path =
  System.get_env("NERVES_SYSTEM") ||
    Mix.raise("You must set NERVES_SYSTEM to the system directory prior to requiring this file")

sdk_sysroot = Path.join(system_path, "staging")

{_toolchain_path, crosscompile} =
  if File.dir?(Path.join(system_path, "host")) do
    # Grab the toolchain from a Buildroot output directory
    toolchain_path = Path.join(system_path, "host")
    gcc_path = Path.join(toolchain_path, "bin")

    crosscompile = Utils.crosscompile(gcc_path, system_path)

    System.put_env("PKG_CONFIG", Path.join(toolchain_path, "bin/pkg-config"))
    System.put_env("PKG_CONFIG_SYSROOT_DIR", sdk_sysroot)
    System.put_env("PKG_CONFIG_LIBDIR", Path.join(sdk_sysroot, "lib/pkgconfig"))
    System.put_env("PKG_CONFIG_PATH", "")
    System.put_env("PERLLIB", Path.join(toolchain_path, "lib/perl"))

    Path.join(toolchain_path, "bin")
    |> System.Env.path_add()

    Path.join(toolchain_path, "lib")
    |> System.Env.ld_library_path_add()

    {toolchain_path, crosscompile}
  else
    # Not a BR Local Provider build
    toolchain_path =
      System.get_env("NERVES_TOOLCHAIN") ||
        Mix.raise(
          "You must set NERVES_TOOLCHAIN to the toolchain directory prior to requiring this file"
        )

    gcc_path = Path.join(toolchain_path, "bin")

    # Find the crosscompilers
    crosscompile = Utils.crosscompile(gcc_path, system_path)

    # Add toolchain bin to path
    Path.join(toolchain_path, "bin")
    |> System.Env.path_add()

    System.put_env("CMAKE_TOOLCHAIN_FILE", Path.expand(Path.join(__DIR__, "nerves-env.cmake")))

    {toolchain_path, crosscompile}
  end

System.put_env("NERVES_SDK_IMAGES", Path.join(system_path, "images"))
System.put_env("NERVES_SDK_SYSROOT", sdk_sysroot)

unless File.dir?(Path.join(system_path, "staging")) do
  Mix.raise("ERROR: It looks like the system hasn't been built!")
end

System.put_env("CROSSCOMPILE", crosscompile)

erts_dir =
  Path.join(sdk_sysroot, "usr/lib/erlang/erts-*")
  |> Path.wildcard()
  |> List.first()

System.put_env("ERTS_DIR", erts_dir)

erl_interface_dir =
  Path.join(sdk_sysroot, "/usr/lib/erlang/lib/erl_interface-*")
  |> Path.wildcard()
  |> List.first()

System.put_env("ERL_INTERFACE_DIR", erl_interface_dir)

erl_lib_dir = Path.join(sdk_sysroot, "/usr/lib/erlang")
System.put_env("REBAR_PLT_DIR", erl_lib_dir)
System.put_env("ERL_LIB_DIR", erl_lib_dir)

erl_system_lib_dir = Path.join(erl_lib_dir, "/lib")
System.put_env("ERL_SYSTEM_LIB_DIR", erl_system_lib_dir)

# Override Make implicit variables with their crosscompile versions
# https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
System.put_env("AR", "#{crosscompile}-ar")
System.put_env("AS", "#{crosscompile}-as")
System.put_env("CC", "#{crosscompile}-gcc")
System.put_env("CXX", "#{crosscompile}-g++")
System.put_env("LD", "#{crosscompile}-ld")
System.put_env("STRIP", "#{crosscompile}-strip")

# Set defaults for compiler flags
System.put_env(
  "CFLAGS",
  "-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -O2 --sysroot #{sdk_sysroot}"
)

System.put_env(
  "CPPFLAGS",
  "-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 --sysroot #{sdk_sysroot}"
)

System.put_env(
  "CXXFLAGS",
  "-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -O2 --sysroot #{sdk_sysroot}"
)

System.put_env("LDFLAGS", "--sysroot=#{sdk_sysroot}")
System.put_env("ERL_CFLAGS", "-I#{erts_dir}/include -I#{erl_interface_dir}/include")
System.put_env("ERL_LDFLAGS", "-L#{erl_interface_dir}/lib -lei")

# pkg-config
System.put_env("PKG_CONFIG_SYSROOT_DIR", sdk_sysroot)
System.put_env("PKG_CONFIG_LIBDIR", "#{sdk_sysroot}/usr/lib/pkgconfig")

# Qt/Qmake support
qmakespec_dir = Path.join(system_path, "staging/mkspecs/devices/linux-buildroot-g++")

if File.dir?(qmakespec_dir) do
  System.put_env("QMAKESPEC", qmakespec_dir)
end

# Rebar naming
System.put_env("REBAR_TARGET_ARCH", Path.basename(crosscompile))
System.put_env("ERL_EI_LIBDIR", Path.join(erl_interface_dir, "lib"))
System.put_env("ERL_EI_INCLUDE_DIR", Path.join(erl_interface_dir, "include"))

# erlang.mk naming
System.put_env("ERTS_INCLUDE_DIR", "#{erts_dir}/include")
System.put_env("ERL_INTERFACE_LIB_DIR", Path.join(erl_interface_dir, "lib"))
System.put_env("ERL_INTERFACE_INCLUDE_DIR", Path.join(erl_interface_dir, "include"))

# Host tools
System.put_env("AR_FOR_BUILD", "ar")
System.put_env("AS_FOR_BUILD", "as")
System.put_env("CC_FOR_BUILD", "cc")
System.put_env("GCC_FOR_BUILD", "gcc")
System.put_env("CXX_FOR_BUILD", "g++")
System.put_env("LD_FOR_BUILD", "ld")
System.put_env("CPPFLAGS_FOR_BUILD", "")
System.put_env("CFLAGS_FOR_BUILD", "")
System.put_env("CXXFLAGS_FOR_BUILD", "")
System.put_env("LDFLAGS_FOR_BUILD", "")

host_erl_major_ver = :erlang.system_info(:otp_release) |> to_string

[target_erl_major_version | _] =
  sdk_sysroot
  |> Path.join("/usr/lib/erlang/releases/*/OTP_VERSION")
  |> Path.wildcard()
  |> List.first()
  |> File.read!()
  |> String.trim()
  |> String.split(".")

# Check to see if the system major version of ERL and the target major version match
if host_erl_major_ver != target_erl_major_version do
  Mix.raise("""
  Major version mismatch between host and target Erlang/OTP versions
    Host version: #{host_erl_major_ver}
    Target version: #{target_erl_major_version}

  This will likely cause Erlang code compiled for the target to fail in
  unexpected ways.

  The easiest way to resolve this issue is to install the same version of
  Erlang/OTP on your host. See the Nerves installation guide for doing this
  using the `asdf` version manager.

  The Nerves System (nerves_system_*) dependency determines the OTP version
  running on the target. It is possible that a recent update to the Nerves
  System pulled in a new version of Erlang/OTP. If you are using an official
  Nerves System, you can verify this by reviewing the CHANGELOG.md file that
  comes with the release. Run 'mix deps' to see the Nerves System version and
  go to that system's repository on https://github.com/nerves-project.

  If you need to run a particular version of Erlang/OTP on your target, you can
  either lock the nerves_system_* dependency in your mix.exs to an older
  version. Note that this route prevents you from receiving security updates
  from the official systems. The other option is to build a custom Nerves
  system. See the Nerves documentation for building a custom system and then
  run 'make menuconfig' and look for the Erlang options.
  """)
end
