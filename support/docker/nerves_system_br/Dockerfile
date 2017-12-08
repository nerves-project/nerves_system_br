FROM buildroot/base
LABEL maintainer="Nerves Project developers <nerves@nerves-project.org>" \
      vendor="NervesProject" \
description="Container with everything needed to build Nerves Buildroot Systems"

# Setup environment
# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8 C.UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV DEBIAN_FRONTEND noninteractive
# The container has no package lists, so need to update first
RUN apt-get update -y -qq \
  && apt-get install -y \
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
    libz-dev \
    xz-utils \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -q -y autoremove \
  && apt-get -q -y clean
