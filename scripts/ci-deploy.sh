#!/bin/sh

# Collect the build artifacts and put them in a directory
# for Travis-CI to publish

# The following environment variables are used:
#  NERVES_CONFIG - e.g. nerves_bbb
#  TRAVIS - On Travis-CI, this is "true"
#  TRAVIS_PULL_REQUEST - Must be "false". Travis should not invoke this script on pull requests
#  TRAVIS_TAG - The tag name if a tagged build
#  TRAVIS_BRANCH - The branch name

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
    fi
else
    # Use git to figure out the branch or tag. This doesn't
    # work on Travis due to how it clones the builds.
    BRANCH_OR_TAG=$(git describe --exact-match 2>/dev/null || git rev-parse --abbrev-ref HEAD)
fi

# Copy the artifacts to a location that's easy to reference in the .travis.yml
rm -fr artifacts
mkdir artifacts
cp nerves-system.tar.gz artifacts/nerves-system-$NERVES_CONFIG-$BRANCH_OR_TAG.tar.gz
cp buildroot/output/images/*.fw artifacts/$NERVES_CONFIG-$BRANCH_OR_TAG.fw # only one .fw file in images
