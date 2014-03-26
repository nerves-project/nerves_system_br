#!/bin/sh

# Script for cloning or downloading a buildroot release. If the buildroot
# release has been cached, use that one. If not, clone and cache the results.
#
# clone_or_dnload.sh <Clone URL> <Hash tag> <Download directory>

set -e
export LC_ALL=C

URL=$1
HASHTAG=$2
DL=$3

[ -z "$URL" ] && { echo "Need to specify a URL to clone from"; exit 1; }
[ -z "$HASHTAG" ] && { echo "Need to specify a hash tag to check out"; exit 1; }
[ -z "$DL" ] && { echo "Need to specify the download directory"; exit 1; }

BASENAME=`basename $URL .git`
CACHED_PATH=$DL/$BASENAME-$HASHTAG.tgz

# Clean up in case we were interrupted during a previous download
rm -fr $BASENAME

if [ -e "$CACHED_PATH" ]; then
    tar xf $CACHED_PATH
else
    git clone $URL
    cd $BASENAME && git checkout -b nerves $HASHTAG
    git archive --format=tar.gz --prefix=$BASENAME/ $HASHTAG > $CACHED_PATH
fi

