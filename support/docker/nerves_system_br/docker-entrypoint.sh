#!/bin/bash
set -e

if [[ -n "$UID" ]] && [[ "$UID" != "0" ]] && [[ -n "$GID" ]] && [[ "$GID" != "0" ]]; then
  echo "Setting User"
  echo "UID: $UID"
  echo "GID: $GID"

  groupadd -o -g $GID nerves
  useradd -o -g $GID -u $UID -m nerves

  echo "Switching user"
  su nerves
fi

exec "$@"
