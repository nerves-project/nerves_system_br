#~/bin/sh

# Script for creating rootfs from Erlang release and the base tarball.
#
# create-fs.sh <base squashfs> <Erlang/OTP release directory> <tmpdir> <output rootfs.squashfs path>

set -e
export LC_ALL=C

SCRIPT_NAME=`basename $0`
BASE_FS=$1
RELEASE_DIR=$2
TMPDIR=$3
IMG=$4

# If the toolchain contains a pre-built version of mksquashfs,
# use it; otherwise look for one in the path.
MKSQUASHFS=$NERVES_TOOLCHAIN/usr/bin/mksquashfs
[ -e "$MKSQUASHFS" ] || MKSQUASHFS=$(command -v mksquashfs || echo "/usr/bin/mksquashfs")
if [ ! -e "$MKSQUASHFS" ]; then
    echo "$SCRIPT_NAME: ERROR: Please install mksquashfs first"
    echo
    echo "For example:"
    echo "   sudo apt-get install squashfs"
    echo "   brew install squashfs"
    exit 1
fi

# Create or cleanup our output directory
mkdir -p $TMPDIR
rm -fr $TMPDIR/*

# Check that the release directory exists
if [ ! -d "$RELEASE_DIR" ]; then
    echo "$SCRIPT_NAME: ERROR: Missing Erlang release directory: ($RELEASE_DIR)"
    exit 1
fi

if [ ! -d "$RELEASE_DIR/lib" -o ! -d "$RELEASE_DIR/releases" ]; then
    echo "$SCRIPT_NAME: ERROR: Expecting '$RELEASE_DIR' to contain 'lib' and 'releases' subdirectories"
    exit 1
fi

# Construct the proper path for the Erlang/OTP release
mkdir -p $TMPDIR/srv/erlang
cp -r $RELEASE_DIR/* $TMPDIR/srv/erlang

# Clean up the Erlang release of all the files that we don't need.
# The user should create their releases without source code
# unless they want really big images..
rm -fr $TMPDIR/srv/erlang/bin $TMPDIR/srv/erlang/erts-*

# Delete empty directories
find $TMPDIR/srv/erlang -type d -empty -delete

# Delete any temp files, release tarballs, etc from the base release directory
# Nothing is supposed to be there.
find $TMPDIR/srv/erlang -maxdepth 1 -type f -delete

# Clean up the releases directory
find $TMPDIR/srv/erlang/releases \( -name "*.sh" \
                                 -o -name "*.bat" \
                                 -o -name "*gz" \
                                 -o -name "start.boot" \
                                 -o -name "start_clean.boot" \
                                 \) -delete

# Strip debug information from ELF binaries
# Symbols are still available to the user in the release directory.
EXECUTABLES=$(find $TMPDIR/srv/erlang -type f -perm -100)
for EXECUTABLE in $EXECUTABLES; do
    case $(file -b $EXECUTABLE) in
        *ELF*)
            $CROSSCOMPILE-strip $EXECUTABLE
            ;;
        *script*)
            # Ignore shell scripts
            ;;
        *) ;;
    esac
done

# Append the Erlang/OTP release onto the base image.
cp "$BASE_FS" "$IMG"
$MKSQUASHFS "$TMPDIR" "${IMG}" -no-recovery -no-progress -root-owned >/dev/null

# Clean up
rm -fr $TMPDIR
