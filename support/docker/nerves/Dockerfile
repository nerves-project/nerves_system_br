FROM nervesproject/nerves_system_br:latest
LABEL maintainer="Nerves Project developers <nerves@nerves-project.org>" \
      vendor="NervesProject" \
description="Container with everything needed to build Nerves projects"

# Setup environment
ENV DEBIAN_FRONTEND noninteractive
ENV LANG=C.UTF-8
ENV TERM=xterm
ENV ERLANG_OTP_VERSION=21.0
ENV FWUP_VERSION=1.2.4
ENV ERLANG_PKG='erlang-solutions_1.0_all.deb'
ENV ERLANG_URL="https://packages.erlang-solutions.com/${ERLANG_PKG}"
# The container has no package lists, so need to update first
RUN set -xe \
  && apt-get update \
  && apt-get -y install \
    curl \
    git \
    openssh-client \
    build-essential \
    libssl-dev \
    bc \
    squashfs-tools \
    bison \
    flex \
    gnupg \
  && curl -o "/tmp/${ERLANG_PKG}" ${ERLANG_URL} \
  && dpkg -i "/tmp/${ERLANG_PKG}" \
  && apt-get update \
  && apt-get -y install \
    "esl-erlang=1:${ERLANG_OTP_VERSION}" \
  && rm -rf /var/lib/apt/lists/* \
  && wget https://github.com/fhunleth/fwup/releases/download/v${FWUP_VERSION}/fwup_${FWUP_VERSION}_amd64.deb \
  && dpkg -i fwup_${FWUP_VERSION}_amd64.deb \
  && rm -f *.tar.gz \
  && rm -f fwup_${FWUP_VERSION}_amd64.deb \
  && mkdir -p /root/.ssh \
  && ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts \
  && chmod 700 /root/.ssh \
  && chmod 600 /root/.ssh/known_hosts
