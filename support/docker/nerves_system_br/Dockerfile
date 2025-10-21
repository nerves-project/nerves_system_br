FROM hexpm/erlang:28.1-ubuntu-jammy-20250819
LABEL maintainer="Nerves Project developers <nerves@nerves-project.org>" \
      vendor="NervesProject" \
      description="Container with everything needed to build Nerves Systems"

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENV FWUP_VERSION=1.13.2

# See https://github.com/CircleCI-Public/cimg-base/blob/main/Dockerfile.template for generic setup

# Change default shell for RUN from Dash to Bash
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=dumb \
    PAGER=cat

# Configure environment
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90nerves && \
	echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90nerves && \
	apt-get update && apt-get install -y \
		curl \
		locales \
		sudo \
	&& \
	locale-gen en_US.UTF-8 && \
	rm -rf /var/lib/apt/lists/* && \
	\
	groupadd --gid=1005 nerves && \
	useradd --uid=1005 --gid=nerves --create-home nerves && \
	echo 'nerves ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-nerves && \
	echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep && \
	sudo -u nerves mkdir /home/nerves/project && \
	sudo -u nerves mkdir /home/nerves/bin && \
	sudo -u nerves mkdir -p /home/nerves/.local/bin

ENV PATH=/home/nerves/bin:/home/nerves/.local/bin:$PATH \
	LANG=C.UTF-8 \
	LC_ALL=C.UTF-8

# Set time
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Set the locale
RUN apt-get update && apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8 C.UTF-8/' /etc/locale.gen && \
    locale-gen

# The container has no package lists, so need to update first
RUN apt-get update -y -qq

# Install Buildroot packages (see <Buildroot>/support/docker/DockerFile
RUN apt-get -o APT::Retries=3 install -y --no-install-recommends \
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
    mercurial \
    openssh-server \
    python3 \
    python3-flake8 \
    python3-magic \
    python3-nose2 \
    python3-pexpect \
    python3-pytest \
    rsync \
    shellcheck \
    subversion \
    unzip \
    wget

# Install additional packages for Nerves and fwup
RUN apt-get -o APT::Retries=3 install -y --no-install-recommends \
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
    python3-aiohttp \
    python3-ijson \
    python3-pip \
    python3-requests \
    squashfs-tools \
    xz-utils \
    autoconf \
    automake \
    libtool \
    libarchive-dev \
    libconfuse-dev

# Install packages to make image easier to use
RUN apt-get -o APT::Retries=3 install -y --no-install-recommends \
    sudo \
    vim-tiny \
  && apt-get -q -y autoremove \
  && apt-get -q -y clean \
  && rm -rf var/lib/apt/lists/*

# Build fwup from source for the current architecture
RUN git clone https://github.com/fwup-home/fwup -b v${FWUP_VERSION} \
  && cd fwup \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && rm -rf fwup

# Switch to a non-root user
USER nerves
RUN whoami \
  # opt-out of the new security feature, not needed in a CI environment
  && git config --global --add safe.directory '*'

# Cache GitHub's host key
RUN mkdir -p /home/nerves/.ssh \
  && ssh-keyscan github.com > /home/nerves/.ssh/known_hosts \
  && chmod 700 /home/nerves/.ssh \
  && chmod 600 /home/nerves/.ssh/known_hosts

WORKDIR /home/nerves/project
