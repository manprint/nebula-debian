FROM debian:buster-slim AS builder

ARG NEBULA_VERSION="1.5.2"
ARG NEBULA_URL="https://github.com/slackhq/nebula/releases/download/v${NEBULA_VERSION}/nebula-linux-amd64.tar.gz"

RUN set -eux \
    && apt-get update -qyy \
    && apt-get install -qyy --no-install-recommends --no-install-suggests \
        ca-certificates \
        wget \
    && rm -rf /var/lib/apt/lists/* /var/log/* \
    \
    && wget -O nebula.tar.gz ${NEBULA_URL} \
    && tar -xzvf nebula.tar.gz -C /usr/local/bin/ \
    && rm -rf nebula.tar.gz \
    && nebula -version

FROM debian:buster-slim

COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY ./config/config.example.yml /root/nebula/config/config.example.yml

CMD ["/usr/local/bin/nebula", "-config", "/root/nebula/config/config.yaml"]
