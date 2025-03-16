#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2016 Frank Hunleth
# SPDX-FileCopyrightText: 2021 衣川 亮太
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

TEST_OUTPUT="$PWD/test_output"
TEST_DIR="$PWD"

run_test() {
    TEST=$1
    echo "Running $TEST"
    rm -fr "${TEST_OUTPUT:?}/$TEST"
    ../create-build.sh "$TEST_DIR/$TEST/nerves_defconfig" "$TEST_OUTPUT/$TEST"
    make -C "$TEST_OUTPUT/$TEST" source all legal-info
    echo "$TEST succeeded"
}

# Add tests here
run_test smoke-test

echo
echo "All tests passed!"
echo

# Clean up
rm -fr "$TEST_OUTPUT"
