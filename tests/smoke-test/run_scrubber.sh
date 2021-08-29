#!/usr/bin/env bash

env

CROSSCOMPILE="$HOST_DIR/bin/arm-none-linux-gnueabihf" "$NERVES_DEFCONFIG_DIR/../../scripts/scrub-otp-release.sh" "$TARGET_DIR/srv/erlang"
