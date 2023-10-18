FROM openjdk:11-jdk-slim AS envoy-tracing-server-app-build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    wget \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/server-app/

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

COPY . .
RUN ./mvnw clean package

FROM envoyproxy/envoy:v1.27-latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
      openjdk-11-jre \
      tzdata \
      ca-certificates \
    && rm -rf /var/lib/apt/lists/*

VOLUME /tmp
WORKDIR /opt/server-app/

ARG jar_file=target/server-app-1.0.0.RELEASE.jar
COPY --from=envoy-tracing-server-app-build /opt/server-app/${jar_file} ./app.jar
COPY --from=envoy-tracing-server-app-build /opt/server-app/libcxx-libinstana_sensor.so ./

COPY ./start-server-app.sh ./envoy-server-app.yaml ./
ENTRYPOINT ["./start-server-app.sh"]

CMD ["java","-jar","app.jar"]
