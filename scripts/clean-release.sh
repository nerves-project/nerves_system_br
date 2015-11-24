#~/bin/sh

# Clean up an Erlang release directory
#
# clean-release.sh <Erlang/OTP release directory>

set -e
export LC_ALL=C

SCRIPT_NAME=`basename $0`
RELEASE_DIR=$1

# Check that the release directory exists
if [ ! -d "$RELEASE_DIR" ]; then
    echo "$SCRIPT_NAME: ERROR: Missing Erlang release directory: ($RELEASE_DIR)"
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

# Strip debug information from ELF binaries
# Symbols are still available to the user in the release directory.
EXECUTABLES=$(find $RELEASE_DIR -type f -perm -100)
for EXECUTABLE in $EXECUTABLES; do
    case $(file -b $EXECUTABLE) in
        *ELF*)
            $STRIP $EXECUTABLE
            ;;
        *script*)
            # Ignore shell scripts
            ;;
        *) ;;
    esac
done
