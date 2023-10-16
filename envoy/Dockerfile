# Original from envoyproject/envoy:examples/front-proxy/Dockerfile-frontenvoy
FROM envoyproxy/envoy:v1.27-latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    wget \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/envoy/

# download latest libinstana_sensor from artifactory
ARG agent_key
ARG download_key
ENV ARTI_PATH='https://artifact-public.instana.io/artifactory/shared/com/instana/libinstana_sensor/' \
    INSTANA_DOWNLOAD_KEY=${download_key} \
    INSTANA_AGENT_KEY=${agent_key}

RUN access_key=$([ ! -z "${INSTANA_DOWNLOAD_KEY}" ] && echo "${INSTANA_DOWNLOAD_KEY}" || echo "${INSTANA_AGENT_KEY}") \
    && wget --user _ --password ${access_key} --output-document=./list.html ${ARTI_PATH} \
    && sensor_version=$(grep -o "href=\"[0-9]\+\.[0-9]\+\.[0-9]\+/\"" ./list.html | tail -n1 | cut -d'"' -f2) \
    && echo "Using sensor version ${sensor_version}" \
    && wget --user _ --password ${access_key} --output-document=./libcxx-libinstana_sensor.so ${ARTI_PATH}${sensor_version}linux-amd64-libcxx-libinstana_sensor.so

COPY ./start-gateway.sh ./envoy-gateway.yaml ./

CMD ["./start-gateway.sh"]
