# Configurations are now stored external to this project

See the `nerves_system_bbb`, `nerves_system_rpi`, etc. projects on GitHub.
This allows the configurations to be updated independent of `nerves_system_br`
and supports integration with `mix`.

# Previous documentation

*Integrate this with a guide to creating system images*

This README documents Nerves-specific configuration of Buildroot that may not be obvious.

## UTF-8

If unchanged, the default locale is "C" using the latin1 encoding. This can be
checked by calling `file:native_name_encoding/0`. Elixir produces a warning
when loading if not using UTF-8. The following configuration items enable UTF-8 at
the cost of adding the file `locale-archive` to the root filesystem.

```
BR2_ENABLE_LOCALE_PURGE=y
BR2_ENABLE_LOCALE_WHITELIST="locale-archive"
BR2_GENERATE_LOCALE="en_US.UTF-8"
```

You will also need to update the environment variables being passed to start
the Erlang VM. This can be done via the `erlinit` configuration. Specify:

    -e LANG=en_US.UTF-8;LANGUAGE=en

## OpenSSL

Buildroot can be configured to build a version of Erlang without OpenSSL, but it
effectively prevents one from using Cowboy and other web frameworks, so it is
enabled by default. See:

```
BR2_PACKAGE_OPENSSL=y
```

## Linux config - code page 437

`CONFIG_NLS_CODEPAGE_437` and `CONFIG_NLS_ISO8859` need to be enabled or mounting FAT filesystems created by
fwup will fail or mount readonly.
