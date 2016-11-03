FROM debian:jessie

MAINTAINER Adrian Goins <mon@chus.cc>

RUN apt-get update && apt-get -qq install apt-transport-https wget && \
    wget -qO - https://apt.z.cash/zcash.asc | apt-key add - && \
    echo "deb [arch=amd64] https://apt.z.cash/ jessie main" > /etc/apt/sources.list.d/zcash.list && \
    apt-get update && \
    apt-get -qq install zcash && \
    rm -fr /var/lib/apt/lists/*

# Install [dumb-init](https://github.com/Yelp/dumb-init)
ENV DI_VERSION 1.1.3
RUN cd /tmp && \
    wget -q -O /bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DI_VERSION}/dumb-init_${DI_VERSION}_amd64 && \
    chmod +x /bin/dumb-init

VOLUME /root/.zcash
VOLUME /root/.zcash-params

WORKDIR /root/.zcash

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/oskapt/docker-zcash"

CMD ["/bin/dumb-init", "zcashd"]
