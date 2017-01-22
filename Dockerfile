# Dockerfile for icinga2 dashing
# Usable in combination with docker

FROM debian:jessie

MAINTAINER Benedikt Heine

ENV ICINGA2_DASHING_API_USER=dashing \
    ICINGA2_DASHING_API_PASS=dashing \
    ICINGA2_DASHING_API_HOST=icinga \
    ICINGA2_DASHING_API_PORT=5665

ARG GITREF_DASHING=master

RUN mkdir -p /usr/local/share/dashing-icinga2/ \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
          g++ \
          libssl-dev \
          make \
          nodejs \
          ruby \
          ruby-dev \
          wget \
    && wget -q --no-cookies -O - "https://github.com/Icinga/dashing-icinga2/archive/${GITREF_DASHING}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/local/share/dashing-icinga2 -f - dashing-icinga2-${GITREF_DASHING}/ \
    && gem install bundler dashing \
    && cd /usr/local/share/dashing-icinga2 \
    && bundle install --system \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD run /srv/run

EXPOSE 3030

ENTRYPOINT ["/srv/run"]
