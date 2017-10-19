FROM buildroot/base
LABEL maintainer="Nerves Project developers <nerves@nerves-project.org>" \
      vendor="NervesProject" \
description="Container with everything needed to build Nerves Buildroot Systems"

# Setup environment
ENV DEBIAN_FRONTEND noninteractive
# The container has no package lists, so need to update first
RUN apt-get update -y -qq
RUN apt-get install -y \
  git \
  g++ \
  libssl-dev \
  libncurses5-dev \
  bc \
  m4 \
  make \
  unzip \
  cmake \
  bzip2 \
  wget \
  python \
  cpio \
  libc6:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  xz-utils && \
  rm -rf /var/lib/apt/lists/*
RUN apt-get -q -y autoremove
RUN apt-get -q -y clean

# To be able to generate a toolchain with locales, enable one UTF-8 locale
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen
RUN /usr/sbin/locale-gen
