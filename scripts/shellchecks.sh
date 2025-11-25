#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2022 Jon Carstens
#
# SPDX-License-Identifier: Apache-2.0
#
set -e

if ! command -v shellcheck &> /dev/null
then
    echo "shellcheck not be found"
    echo "See https://github.com/koalaman/shellcheck#installing"
    exit 1
fi

find ./ -name "*.sh" -exec shellcheck {} \+
