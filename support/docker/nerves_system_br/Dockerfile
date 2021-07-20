FROM hexpm/erlang:24.0.3-ubuntu-focal-20210325
LABEL maintainer="Nerves Project developers <nerves@nerves-project.org>" \
      vendor="NervesProject" \
description="Container with everything needed to build Nerves Systems"

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV FWUP_VERSION=1.9.0
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

COPY docker-entrypoint.sh /nerves/docker-entrypoint.sh
RUN chmod +x /nerves/docker-entrypoint.sh

# Set time
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Set the locale
RUN apt-get update && apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8 C.UTF-8/' /etc/locale.gen && \
    locale-gen

# The container has no package lists, so need to update first
RUN dpkg --add-architecture i386 && \
    apt-get update -y -qq
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
        g++-multilib \
        git \
        libc6-i386 \
        libncurses5-dev \
        locales \
        mercurial \
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
# Install additional packages for Nerves
RUN apt-get install -y --no-install-recommends \
    bzip2 \
    curl \
    gawk \
    gcc-multilib \
    gnupg \
    gosu \
    jq \
    libmnl-dev \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz-dev \
    libssl-dev \
    openssh-client \
    pkg-config \
    squashfs-tools \
    vim-tiny \
    xz-utils
RUN rm -rf /var/lib/apt/lists/* \
  && mkdir -p /root/.ssh \
  && ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts \
  && chmod 700 /root/.ssh \
  && chmod 600 /root/.ssh/known_hosts \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -q -y autoremove \
  && apt-get -q -y clean \
  && mkdir -p /nerves/build && chmod 777 /nerves/build

RUN wget https://github.com/fhunleth/fwup/releases/download/v${FWUP_VERSION}/fwup_${FWUP_VERSION}_amd64.deb \
  && dpkg -i fwup_${FWUP_VERSION}_amd64.deb \
  && rm -f *.tar.gz \
  && rm -f fwup_${FWUP_VERSION}_amd64.deb

ENTRYPOINT [ "/nerves/docker-entrypoint.sh" ]
