#!/usr/bin/env bash

set -e

TEST_OUTPUT="$PWD/test_output"
TEST_DIR="$PWD"

run_test() {
    TEST=$1
    echo "Running $TEST"
    rm -fr "${TEST_OUTPUT:?}/$TEST"
    ../create-build.sh "$TEST_DIR/$TEST/nerves_defconfig" "$TEST_OUTPUT/$TEST"
    make -C "$TEST_OUTPUT/$TEST" source all pkg-stats legal-info
    echo "$TEST succeeded"
}

# Add tests here
run_test smoke-test

echo
echo "All tests passed!"
echo

# Clean up
rm -fr "$TEST_OUTPUT"
