#!/usr/bin/env bash

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

if [ ! -d "$RELEASE_DIR/lib" ] || [ ! -d "$RELEASE_DIR/releases" ]; then
    echo "$SCRIPT_NAME: ERROR: Expecting '$RELEASE_DIR' to contain 'lib' and 'releases' subdirectories"
    exit 1
fi

STRIP="$CROSSCOMPILE-strip"
READELF="$CROSSCOMPILE-readelf"
if [ ! -e "$STRIP" ] || [ ! -e "$READELF" ]; then
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

# Delete empty directories
find "$RELEASE_DIR" -type d -empty -delete

# Delete any temp files, release tarballs, etc from the base release directory
# Nothing is supposed to be there.
find "$RELEASE_DIR" -maxdepth 1 -type f -delete

# Clean up the releases directory
find "$RELEASE_DIR/releases" \( -name "*.sh" \
                                 -o -name "*.bat" \
                                 -o -name "*.ps1" \
                                 -o -name "*gz" \
                                 -o -name "*.script" \
                                 \) -delete

#
# Scrub the executables
#

executable_type()
{
    FILE=$1

    # Try readelf first, since it's output seems more trustworthy for executables
    READELF_OUTPUT=$("$READELF" -h "$FILE" 2>/dev/null || true)
    if [ "$READELF_OUTPUT" ]; then
        ELF_MACHINE=$(echo "$READELF_OUTPUT" | sed -E -e '/^  Machine: +(.+)/!d; s//\1/;' | head -1)
        ELF_FLAGS=$(echo "$READELF_OUTPUT" | sed -E -e '/^  Flags: +(.+)/!d; s//\1/;' | head -1)

        if [ -z "$ELF_MACHINE" ]; then
            echo "$SCRIPT_NAME: ERROR: Didn't expect empty machine field in ELF header in $FILE." 1>&2
            echo "   Try running '$READELF -h $FILE' and" 1>&2
            echo "   and create an issue at https://github.com/nerves-project/nerves_system_br/issues." 1>&2
            exit 1
        fi
        echo "readelf:$ELF_MACHINE;$ELF_FLAGS"
    else
        # readelf didn't work, so try file and guess at things that will cause problems
        FILE_OUTPUT=$(file -b -h "$FILE")
        case "$FILE_OUTPUT" in
            *shared*library*)
                echo "file:$FILE_OUTPUT"
                ;;

            *x86_64*)
                echo "file:$FILE_OUTPUT"
                ;;

            *)
                echo "portable"
                ;;
        esac
    fi
}

get_expected_executable_type()
{
    # Compile a trivial C program with the crosscompiler
    # so that we know what the `file` output should look like.
    tmpfile=$(mktemp /tmp/scrub-otp-release.XXXXXX)
    echo "int main() {}" | "$CROSSCOMPILE-gcc" -x c -o "$tmpfile" -
    executable_type "$tmpfile"
    rm "$tmpfile"
}

# searches for a file named `.noscrub`. If found
# filter that folder out of the `EXECUTABLES` list later
NOSCRUBS=$(find "$RELEASE_DIR" -name ".noscrub" -exec dirname {} \;)

noscrub()
{
    # Using `find` across various MacOS systems differs which may
    # cause errors. So we manually cycling throught the noscrub
    # list until finding a match which may be less performant
    # than `find`, but reduces errors. The noscrub list should
    # generally be small and is only called at the last moment
    # after we've determined the file type is different
    for noscrub in $NOSCRUBS; do
        if [[ "$1" == "$noscrub"* ]]; then
            return 0
        fi
    done

    return 1
}

EXECUTABLES=$(find "$RELEASE_DIR" -type f -perm -100)
EXPECTED_TYPE=$(get_expected_executable_type)

for EXECUTABLE in $EXECUTABLES; do
    TYPE=$(executable_type "$EXECUTABLE")

    if [ "$TYPE" != "portable" ]; then
        # Verify that the executable was compiled for the target
        if [ "$TYPE" != "$EXPECTED_TYPE" ]; then
            if noscrub "$EXECUTABLE"; then
                # Skip any errors or attempts to strip
                continue
            fi
            echo "$SCRIPT_NAME: ERROR: Unexpected executable format for '$EXECUTABLE'"
            echo
            echo "Got:"
            echo " $TYPE"
            echo
            echo "Expecting:"
            echo " $EXPECTED_TYPE"
            echo
            echo "This file was compiled for the host or a different target and probably"
            echo "will not work."
            echo
            echo "Check the following:"
            echo
            echo "1. Are you using a path dependency in your mix deps? If so, run"
            echo "   'mix clean' in that directory to avoid pulling in any of its"
            echo "   build products."
            echo
            echo "2. Did you recently upgrade to Elixir 1.9 or Nerves 1.5?"
            echo "   Nerves 1.5 adds support for Elixir 1.9 Releases and requires"
            echo "   you to either add an Elixir 1.9 Release configuration or add"
            echo "   Distillery as a dependency. Without this, the OTP binaries"
            echo "   for your build machine will get included incorrectly and cause"
            echo "   this error. See"
            echo "   https://hexdocs.pm/nerves/updating-projects.html#updating-from-v1-4-to-v1-5"
            echo
            echo "3. Did you recently upgrade or change your Nerves system? If so,"
            echo "   try cleaning and rebuilding this project and its deps."
            echo
            echo "4. Are you building outside of Nerves' mix integration? If so,"
            echo "   make sure that you've sourced 'nerves-env.sh'."
            echo
            echo "If you are very sure you know what you are doing, you may place an empty"
            echo "file in the same directory as the offending file(s) called '.noscrub'."
            echo "This will explicitly disable scrubbing for that directory."
            echo
            echo "If you're still having trouble, please file an issue on Github"
            echo "at https://github.com/nerves-project/nerves_system_br/issues."
            echo
            exit 1
        fi

        # Strip debug information from ELF binaries
        # Symbols are still available to the user in the release directory.
        if ! $STRIP "$EXECUTABLE"; then
            echo "WARNING: Can't remove debug symbols from $EXECUTABLE. This is expected for precompiled Rust."
        fi
    fi
done
