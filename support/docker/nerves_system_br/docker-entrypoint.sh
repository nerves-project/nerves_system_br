#!/usr/bin/env bash
set -e

if [[ -n "$UID" ]] && [[ "$UID" != "0" ]] && [[ -n "$GID" ]] && [[ "$GID" != "0" ]]; then
  echo "Setting User"
  echo "UID: $UID"
  echo "GID: $GID"

  groupadd -o -g "$GID" nerves
  useradd -o -g "$GID" -u "$UID" -M nerves
  cp -pr /etc/skel/. ~nerves

  echo "Switching user"

  gosu nerves "$@"
else
  exec "$@"
fi


