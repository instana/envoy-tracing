FROM ubuntu:20.04 AS tracing_dependencies

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y lynx curl ca-certificates gnupg2 unzip

ARG agent_key
ARG download_key
ARG nginx_version
# For Alpine-based images, change the following to 'musl'
ARG libc_flavor=glibc

ENV INSTANA_AGENT_KEY=${agent_key}
ENV INSTANA_DOWNLOAD_KEY=${download_key}
ENV LIBC_FLAVOR=${libc_flavor}
ENV ARTI_PATH='https://artifact-public.instana.io/artifactory/shared/com/instana/libinstana_sensor/'

# Download extension from Artifactory
RUN key=$([ -n "${INSTANA_DOWNLOAD_KEY}" ] && echo "${INSTANA_DOWNLOAD_KEY}" || echo "${INSTANA_AGENT_KEY}"); \
    libcflavor=$([ "${LIBC_FLAVOR}" = 'glibc' ] || echo '-musl' ) ; \
    echo "Using download key ${key}; LIBC flavor: ${LIBC_FLAVOR}"; \ 
    sensor_version=$(lynx -auth _:${key} -dump -listonly ${ARTI_PATH} | grep -o 'https:.*/[0-9]\+\.[0-9]\+\.[0-9]\+/' | rev | cut -d '/' -f 2 | rev | sort -V | tail -n1); \
    echo "Using sensor version ${sensor_version}"; \
    mkdir -p /opt/instana/envoy ; \
    curl --fail --user _:${key} --silent --output /opt/instana/envoy/libinstana_sensor.so ${ARTI_PATH}/${sensor_version}/linux-amd64${libcflavor}-libinstana_sensor.so

FROM envoyproxy/envoy:v1.14.4

COPY --from=tracing_dependencies /opt/instana/envoy/libinstana_sensor.so /opt/instana/envoy/libinstana_sensor.so
COPY ./envoy-gateway.yaml /etc/envoy/envoy.yaml
