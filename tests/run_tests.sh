#!/bin/bash

set -e

run_test() {
    TEST=$1
    echo Running $TEST
    rm -fr output
    make -C .. O=$PWD/output DEFCONFIG=$PWD/$TEST/test_defconfig config
    make -C output
    rm -fr output
    echo $TEST succeeded
}


run_test test-rootfs-additions
run_test test-user-package

echo
echo All tests passed!
echo
