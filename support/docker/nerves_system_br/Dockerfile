FROM ubuntu:18.04
LABEL maintainer="Nerves Project developers <nerves@nerves-project.org>" \
      vendor="NervesProject" \
description="Container with everything needed to build Nerves Systems"

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV ERLANG_OTP_VERSION=22.2.1-1
ENV FWUP_VERSION=1.5.1
ENV ERLANG_PKG='erlang-solutions_1.0_all.deb'
ENV ERLANG_URL="https://packages.erlang-solutions.com/${ERLANG_PKG}"
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
RUN dpkg --add-architecture i386 \
  && apt-get update -y -qq \
  && apt-get install -y -qq \
    gosu \
    bzr \
    ca-certificates \
    cvs \
    file \
    g++-multilib \
    mercurial \
    python-flake8 \
    python-nose2 \
    python-pexpect \
    python3-distutils \
    rsync \
    subversion \
    unzip \
    g++ \
    libssl-dev \
    libncurses5-dev \
    bc \
    m4 \
    make \
    cmake \
    bzip2 \
    bison \
    flex \
    wget \
    python \
    cpio \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz-dev \
    xz-utils \
    gcc-multilib \
    g++-multilib \
    curl \
    git \
    openssh-client \
    build-essential \
    libssl-dev \
    bc \
    squashfs-tools \
    gnupg \
    libmnl-dev \
    gawk \
    jq \
    pkg-config \
    vim-tiny \
  && curl -o "/tmp/${ERLANG_PKG}" ${ERLANG_URL} \
  && dpkg -i "/tmp/${ERLANG_PKG}" \
  && apt-get update \
  && apt-get -y install \
    "esl-erlang=1:${ERLANG_OTP_VERSION}" \
  && rm -rf /var/lib/apt/lists/* \
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
