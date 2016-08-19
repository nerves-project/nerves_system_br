#~/bin/sh

# Remove or minimize files in an Erlang/OTP release directory
# in preparation for use packaging in a Nerves firmware image.
#
# scrub-otp-release.sh <Erlang/OTP release directory>

set -e
export LC_ALL=C

SCRIPT_NAME=$(basename $0)
RELEASE_DIR=$1

# Check that the release directory exists
if [ ! -d "$RELEASE_DIR" ]; then
    echo "$SCRIPT_NAME: ERROR: Missing Erlang/OTP release directory: ($RELEASE_DIR)"
    exit 1
fi

if [ ! -d "$RELEASE_DIR/lib" -o ! -d "$RELEASE_DIR/releases" ]; then
    echo "$SCRIPT_NAME: ERROR: Expecting '$RELEASE_DIR' to contain 'lib' and 'releases' subdirectories"
    exit 1
fi

if [ -e $CROSSCOMPILE-strip ]; then
    STRIP=$CROSSCOMPILE-strip
else
    echo "$SCRIPT_NAME: ERROR: Expecting \$CROSSCOMPILE to be set. Did you source nerves-env.sh?"
fi

# Clean up the Erlang release of all the files that we don't need.
# The user should create their releases without source code
# unless they want really big images..
rm -fr $RELEASE_DIR/bin $RELEASE_DIR/erts-*

# Delete empty directories
find $RELEASE_DIR -type d -empty -delete

# Delete any temp files, release tarballs, etc from the base release directory
# Nothing is supposed to be there.
find $RELEASE_DIR -maxdepth 1 -type f -delete

# Clean up the releases directory
find $RELEASE_DIR/releases \( -name "*.sh" \
                                 -o -name "*.bat" \
                                 -o -name "*gz" \
                                 -o -name "start.boot" \
                                 -o -name "start_clean.boot" \
                                 \) -delete

#
# Scrub the executables
#

executable_type()
{
    # Run 'file' on $1, trim out parts
    # that can vary on a platform, and
    # normalize whitespace

    # NOTE: The SYSV vs. GNU/Linux part has to be removed
    #       since C++ template instantiation enables the
    #       GNU/Linux extension, but doesn't actually
    #       break anything.
    file -b $1 \
        | sed 's/, BuildID[^,]*,/,/g' \
        | sed 's/, dynamically linked,/,/g' \
        | sed 's/,[^,]*stripped//g' \
        | sed 's/[[:space:]]\+/ /g' \
        | sed 's/[[:space:]]*(SYSV)//g' \
        | sed 's/[[:space:]]*(GNU\/Linux)//g'
}

get_expected_dynamic_executable_type()
{
    # Compile a trivial C program with the crosscompiler
    # so that we know what the `file` output should look like.
    tmpfile=$(mktemp /tmp/scrub-otp-release.XXXXXX)
    echo "int main() {}" | $CROSSCOMPILE-gcc -x c -o $tmpfile -
    echo $(executable_type $tmpfile)
    rm $tmpfile
}

get_expected_static_executable_type()
{
    # Compile a trivial C program with the crosscompiler
    # so that we know what the `file` output should look like.
    tmpfile=$(mktemp /tmp/scrub-otp-release.XXXXXX)
    echo "int main() {}" | $CROSSCOMPILE-gcc -x c -static -o $tmpfile -
    echo $(executable_type $tmpfile)
    rm $tmpfile
}

get_expected_library_type()
{
    # Compile a trivial C shared library with the crosscompiler
    # so that we know what the `file` output should look like.
    tmpfile=$(mktemp /tmp/scrub-otp-release.XXXXXX)
    echo "void doit() {}" | $CROSSCOMPILE-gcc --shared -x c -o $tmpfile -
    echo $(executable_type $tmpfile)
    rm $tmpfile
}

EXECUTABLES=$(find $RELEASE_DIR -type f -perm -100)
EXPECTED_DYNAMIC_BIN_TYPE=$(get_expected_dynamic_executable_type)
EXPECTED_STATIC_BIN_TYPE=$(get_expected_static_executable_type)
EXPECTED_SO_TYPE=$(get_expected_library_type)

for EXECUTABLE in $EXECUTABLES; do
    case $(file -b $EXECUTABLE) in
        *ELF*)
            # Verify that the executable was compiled for the target
            TYPE=$(executable_type $EXECUTABLE)
            if [ "$TYPE" != "$EXPECTED_DYNAMIC_BIN_TYPE" -a "$TYPE" != "$EXPECTED_STATIC_BIN_TYPE" -a "$TYPE" != "$EXPECTED_SO_TYPE" ]; then
                echo "$SCRIPT_NAME: ERROR: Unexpected executable format for '$EXECUTABLE'"
                echo
                echo "Got:"
                echo " $TYPE"
                echo
                echo "If binary, expecting:"
                echo " $EXPECTED_DYNAMIC_BIN_TYPE"
                echo
                echo "or, for static binaries:"
                echo " $EXPECTED_STATIC_BIN_TYPE"
                echo
                echo "If shared library, expecting:"
                echo " $EXPECTED_SO_TYPE"
                echo
                echo " This file may have been compiled for the host or a different target."
                echo " Make sure that nerves-env.sh has been sourced and rebuild to fix this."
                echo
                exit 1
            fi

            # Strip debug information from ELF binaries
            # Symbols are still available to the user in the release directory.
            $STRIP $EXECUTABLE
            ;;
        *) ;;
    esac
done
