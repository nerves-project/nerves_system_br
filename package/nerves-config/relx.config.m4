{include_erts, false}.
{include_src, false}.
ifelse(IS_ELIXIR, `y', `
{sys_config, "../../../../package/nerves-config/elixir-sys.config"}.')
{release, {nerves_config, "0.1.0"}, [APPS]}.
