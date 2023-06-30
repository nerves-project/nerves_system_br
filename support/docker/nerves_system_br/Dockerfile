FROM hexpm/erlang:26.0.2-ubuntu-jammy-20230126
LABEL maintainer="Nerves Project developers <nerves@nerves-project.org>" \
      vendor="NervesProject" \
description="Container with everything needed to build Nerves Systems"

USER root

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENV DEBIAN_FRONTEND noninteractive
ENV FWUP_VERSION=1.10.0
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

COPY docker-entrypoint.sh /nerves/docker-entrypoint.sh
COPY setup-packages.sh /nerves/setup-packages.sh

RUN chmod +x /nerves/docker-entrypoint.sh
RUN chmod +x /nerves/setup-packages.sh

# Set time
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Set the locale
RUN apt-get update && apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8 C.UTF-8/' /etc/locale.gen && \
    locale-gen

# The container has no package lists, so need to update first
RUN /nerves/setup-packages.sh && apt-get update -y -qq

# Install our i386 deps first, since they require special config in aarch64 envs
RUN apt-get install -y \
        libc6:i386 \
        libncurses5:i386 \
        gcc-multilib \
        g++-multilib \
        libstdc++6:i386

# Install Buildroot packages (see <Buildroot>/support/docker/DockerFile
RUN apt-get install -y --no-install-recommends \
        bc \
        build-essential \
        bzr \
        ca-certificates \
        cmake \
        cpio \
        cvs \
        file \
        g++ \
        git \
        libncurses5-dev \
        locales \
        mercurial-common \
        python3 \
        python3-aiohttp \
        python3-flake8 \
        python3-ijson \
        python3-nose2 \
        python3-pexpect \
        python3-pip \
        python3-requests \
        rsync \
        subversion \
        unzip \
        wget

# Install additional packages for Nerves and fwup
RUN apt-get install -y --no-install-recommends \
    bzip2 \
    curl \
    gawk \
    gcc \
    gnupg \
    gosu \
    jq \
    libmnl-dev \
    libz-dev \
    libssl-dev \
    openssh-client \
    pkg-config \
    squashfs-tools \
    vim-tiny \
    xz-utils \
    autoconf \
    automake \
    libtool \
    libarchive-dev \
    libconfuse-dev

RUN rm -rf /var/lib/apt/lists/* \
  && mkdir -p /root/.ssh \
  && ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts \
  && chmod 700 /root/.ssh \
  && chmod 600 /root/.ssh/known_hosts \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -q -y autoremove \
  && apt-get -q -y clean \
  && mkdir -p /nerves/build && chmod 777 /nerves/build

# Build fwup from source for the current architecture
RUN git clone https://github.com/fwup-home/fwup -b v${FWUP_VERSION} && cd fwup && ./autogen.sh && ./configure && make && make install
RUN rm -rf fwup

ENTRYPOINT [ "/nerves/docker-entrypoint.sh" ]
