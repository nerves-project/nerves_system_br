#!/bin/sh

# Remove or minimize files in an Erlang/OTP release directory
# in preparation for use packaging in a Nerves firmware image.
#
# scrub-otp-release.sh <Erlang/OTP release directory>

set -e
export LC_ALL=C

SCRIPT_NAME=$(basename "$0")
RELEASE_DIR="$1"

# Check that the release directory exists
if [ ! -d "$RELEASE_DIR" ]; then
    echo "$SCRIPT_NAME: ERROR: Missing Erlang/OTP release directory: ($RELEASE_DIR)"
    exit 1
fi

if [ ! -d "$RELEASE_DIR/lib" -o ! -d "$RELEASE_DIR/releases" ]; then
    echo "$SCRIPT_NAME: ERROR: Expecting '$RELEASE_DIR' to contain 'lib' and 'releases' subdirectories"
    exit 1
fi

STRIP="$CROSSCOMPILE-strip"
READELF="$CROSSCOMPILE-readelf"
if [ ! -e "$STRIP" -o ! -e "$READELF" ]; then
    echo "$SCRIPT_NAME: ERROR: Expecting \$CROSSCOMPILE to be set. Did you source nerves-env.sh?"
    echo "  \"mix firmware\" should do this for you. Please file an issue is using \"mix\"."
    echo "  Additional information:"
    echo "    strip=$STRIP"
    echo "    readelf=$READELF"
    exit 1
fi

# Clean up the Erlang release of all the files that we don't need.
# The user should create their releases without source code
# unless they want really big images..
rm -fr "${RELEASE_DIR:?}/bin" "$RELEASE_DIR"/erts-*

# Delete empty directories
find "$RELEASE_DIR" -type d -empty -delete

# Delete any temp files, release tarballs, etc from the base release directory
# Nothing is supposed to be there.
find "$RELEASE_DIR" -maxdepth 1 -type f -delete

# Clean up the releases directory
find "$RELEASE_DIR/releases" \( -name "*.sh" \
                                 -o -name "*.bat" \
                                 -o -name "*gz" \
                                 -o -name "start.boot" \
                                 -o -name "start_clean.boot" \
                                 \) -delete

#
# Scrub the executables
#

readelf_headers()
{
    if ! "$READELF" -h "$1" 2>/dev/null; then
        echo "not_elf"
    fi
}

executable_type()
{
    FILE="$1"
    READELF_OUTPUT="$2"

    ELF_MACHINE=$(echo "$READELF_OUTPUT" | sed -E -e '/^  Machine: +(.+)/!d; s//\1/;' | head -1)
    ELF_FLAGS=$(echo "$READELF_OUTPUT" | sed -E -e '/^  Flags: +(.+)/!d; s//\1/;' | head -1)

    if [ -z "$ELF_MACHINE" ]; then
        echo "$SCRIPT_NAME: ERROR: Didn't expect empty machine field in ELF header in $FILE." 1>&2
        echo "   Try running '$READELF -h $FILE' and" 1>&2
        echo "   and create an issue at https://github.com/nerves-project/nerves_system_br/issues." 1>&2
        exit 1
    fi
    echo "$ELF_MACHINE;$ELF_FLAGS"
}

get_expected_executable_type()
{
    # Compile a trivial C program with the crosscompiler
    # so that we know what the `file` output should look like.
    tmpfile=$(mktemp /tmp/scrub-otp-release.XXXXXX)
    echo "int main() {}" | "$CROSSCOMPILE-gcc" -x c -o "$tmpfile" -
    executable_type "$tmpfile" "$(readelf_headers "$tmpfile")"
    rm "$tmpfile"
}

EXECUTABLES=$(find "$RELEASE_DIR" -type f -perm -100)
EXPECTED_TYPE=$(get_expected_executable_type)

for EXECUTABLE in $EXECUTABLES; do
    READELF_OUTPUT=$(readelf_headers "$EXECUTABLE")
    if [ "$READELF_OUTPUT" != "not_elf" ]; then
        # Verify that the executable was compiled for the target
        TYPE=$(executable_type "$EXECUTABLE" "$READELF_OUTPUT")
        if [ "$TYPE" != "$EXPECTED_TYPE" ]; then
            echo "$SCRIPT_NAME: ERROR: Unexpected executable format for '$EXECUTABLE'"
            echo
            echo "Got:"
            echo " $TYPE"
            echo
            echo "Expecting:"
            echo " $EXPECTED_TYPE"
            echo
            echo " This file may have been compiled for the host or a different target."
            echo " Make sure that nerves-env.sh has been sourced and rebuild to fix this."
            echo
            exit 1
        fi

        # Strip debug information from ELF binaries
        # Symbols are still available to the user in the release directory.
        $STRIP "$EXECUTABLE"
    fi
done
