FROM buildroot/base
LABEL maintainer="Nerves Project developers <nerves@nerves-project.org>" \
      vendor="NervesProject" \
description="Container with everything needed to build Nerves Buildroot Systems"

# Setup environment
# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

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
