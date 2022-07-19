#!/usr/bin/env bash
set -e
if [[ $TARGETPLATFORM =~ "linux/arm64" ]] ; then
    dpkg --add-architecture 'i386'
    sed 's/^deb http/deb [arch=arm64] http/' -i '/etc/apt/sources.list'

    touch /etc/apt/sources.list.d/i386.list
    echo "deb [arch=i386] http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list.d/i386.list
    echo "deb [arch=i386] http://archive.ubuntu.com/ubuntu/ jammy           main restricted universe multiverse" >> /etc/apt/sources.list.d/i386.list
    echo "deb [arch=i386] http://archive.ubuntu.com/ubuntu/ jammy-updates   main restricted universe multiverse" >> /etc/apt/sources.list.d/i386.list
    echo "deb [arch=i386] http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/i386.list
else
    dpkg --add-architecture i386
fi