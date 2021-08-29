#!/usr/bin/env bash

# Collect the build artifacts and put them in a directory
# for Travis-CI to publish

# The following environment variables are used:
#  CI_DEFCONFIG_DIR    - the name of the directory under configs
#  CI_DEFCONFIG        - the part of the filename that comes before _defconfig
#  TRAVIS              - On Travis-CI, this is "true"
#  TRAVIS_PULL_REQUEST - Must be "false". Travis should not invoke this script on pull requests
#  TRAVIS_TAG          - The tag name if a tagged build
#  TRAVIS_BRANCH       - The branch name

ARTIFACT_SUBDIR=.

# Check if we're building under Travis-ci
if [ "$TRAVIS" = "true" ]; then
    if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
        echo "Not supposed to be deploying pull requests!!"
        exit 1
    fi

    if [ -n "$TRAVIS_TAG" ]; then
        BRANCH_OR_TAG=$TRAVIS_TAG
    else
        BRANCH_OR_TAG=$TRAVIS_BRANCH
        if [ "$TRAVIS_BRANCH" != "master" ]; then
            ARTIFACT_SUBDIR=branch
        fi
    fi
else
    # Use git to figure out the branch or tag. This doesn't
    # work on Travis due to how it clones the builds.
    BRANCH_OR_TAG=$(git describe --exact-match 2>/dev/null || git rev-parse --abbrev-ref HEAD)
fi

# Copy the artifacts to a location that's easy to reference in the .travis.yml
rm -fr artifacts
mkdir -p artifacts/$ARTIFACT_SUBDIR

# shellcheck disable=SC2125
WORK_DIR=_build/*/nerves/system
if [ ! -d "$WORK_DIR" ]; then
  # shellcheck disable=SC2125
  WORK_DIR=.nerves/artifacts/*
fi

cp "$WORK_DIR/${CI_SYSTEM_NAME}.tar.gz" "artifacts/$ARTIFACT_SUBDIR/${CI_SYSTEM_NAME}-$BRANCH_OR_TAG.tar.gz"
cp "$WORK_DIR/images/${CI_SYSTEM_NAME}.fw" "artifacts/$ARTIFACT_SUBDIR/${CI_SYSTEM_NAME}-$BRANCH_OR_TAG.fw" # only one .fw file in images
