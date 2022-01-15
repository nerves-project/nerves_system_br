#!/usr/bin/env bash

set -e

#
# Post create filesystem hook
#
# Inputs:
#   $1  the images directory (where to put the .fw output)
#   $2  the path to fwup.conf
#   $BR2_EXTERNAL_NERVES_PATH the path to the nerves_system_br directory
#   $BASE_DIR     the path to the buildroot output directory
#   $BINARIES_DIR the path to the images directory (normally $BASE_DIR/images)


if [ $# -lt 2 ]; then
    echo "Usage: $0 <BR images directory> <Path to fwup.conf> [Base firmware name]"
    exit 1
fi

FWUP_CONFIG=$2

[ ! -f "$FWUP_CONFIG" ] && { echo "Error: $FWUP_CONFIG not found"; exit 1; }

# Copy the fwup config to the images directory so that
# it can be used to create images based on this one.
cp -f "$FWUP_CONFIG" "$BINARIES_DIR"

# Symlink the nerves scripts to the output directory so that it
# is self-contained.
cp -f "$BR2_EXTERNAL_NERVES_PATH/nerves-env.sh" "$BASE_DIR"    # Can't symlink due to readlink -f code
ln -sf "$BR2_EXTERNAL_NERVES_PATH/nerves-env.cmake" "$BASE_DIR"
ln -sf "$BR2_EXTERNAL_NERVES_PATH/nerves.mk" "$BASE_DIR"
ln -sf "$BR2_EXTERNAL_NERVES_PATH/scripts" "$BASE_DIR"

# If Qt was built, copy its mkspecs to staging so that they're accessible in
# Nerves projects
if [ -e "$BASE_DIR/host/mkspecs" ]; then
    rm -fr "$BASE_DIR/staging/mkspecs"
    cp -r "$BASE_DIR/host/mkspecs" "$BASE_DIR/staging"

    # Replace the absolute paths to sysroot to use an environment variable
    CANONICAL_SYSROOT=$(readlink -f "$BASE_DIR/staging")
    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^$CANONICAL_SYSROOT^\$\$\(NERVES_SDK_SYSROOT)^g" "{}" ";"

    # Replace the absolute paths to the toolchain
    CANONICAL_HOSTBIN=$(readlink -f "$BASE_DIR/host")
    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^$CANONICAL_HOSTBIN^\$\$\(NERVES_TOOLCHAIN)^g" "{}" ";"

    # Fixup includes that pull qmake back into the host's mkspecs
    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^\$\$\[QT_HOST_DATA\]/mkspecs^\$\$\(NERVES_SDK_SYSROOT)/mkspecs^g" "{}" ";"
    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^\$\$\[QT_HOST_DATA/get\]/mkspecs^\$\$\(NERVES_SDK_SYSROOT)/mkspecs^g" "{}" ";"
    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^\$\$\[QT_HOST_DATA/src\]/mkspecs^\$\$\(NERVES_SDK_SYSROOT)/mkspecs^g" "{}" ";"

    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^\$\$\[QT_INSTALL_HEADERS\]^\$\$\(NERVES_SDK_SYSROOT)/usr/include/qt5^g" "{}" ";"
    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^\$\$\[QT_INSTALL_LIBS\]^\$\$\(NERVES_SDK_SYSROOT)/usr/lib^g" "{}" ";"

    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^\$\$\[QMAKE_MKSPECS\]^\$\$\(NERVES_SDK_SYSROOT)/mkspecs^g" "{}" ";"
    find "$BASE_DIR/staging/mkspecs" -type f -exec sed -i "s^\$\$\[QT_SYSROOT\]^\$\$\(NERVES_SDK_SYSROOT)^g" "{}" ";"

fi
