# Much of this was copied from the Buildroot .travis.yml. See
# https://github.com/buildroot/buildroot-defconfig-testing/blob/master/.travis.yml
export DEFCONFIG_NAME="nerves_${NERVES_CONFIG}_defconfig"
export LD_LIBRARY_PATH=

# Configure platform
make --silent $DEFCONFIG_NAME

# Build the SDK
while true ; do echo "Still building" ; sleep 60 ; done &
stupidpid=$!
make > >(tee build.log | grep '>>>') 2>&1
kill ${stupidpid}
echo 'Display end of log'
tail -1000 build.log

# Create artifacts
make system
rm -fr artifacts
mkdir artifacts
cp system.tar.gz artifacts
cp buildroot/output/images/*.fw artifacts
