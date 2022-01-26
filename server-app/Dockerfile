FROM openjdk:11-jdk-slim AS evnoy-tracing-server-app-build

ARG agent_key
ENV INSTANA_AGENT_KEY=${agent_key}
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y --no-install-recommends --no-install-suggests \
    curl \
    lynx \
    ca-certificates

WORKDIR /opt/server-app/

# download latest libinstana_sensor from artifactory
RUN sensor_version=$(lynx -auth _:${INSTANA_AGENT_KEY} -dump -listonly https://artifact-public.instana.io/artifactory/shared/com/instana/libinstana_sensor/ | grep -o 'https:.*/[0-9]\+\.[0-9]\+\.[0-9]\+/' | rev | cut -d '/' -f 2 | rev | sort -V | tail -n1) \
    && curl --user _:${INSTANA_AGENT_KEY} --silent --output ./libinstana_sensor.so https://artifact-public.instana.io/artifactory/shared/com/instana/libinstana_sensor/${sensor_version}/linux-amd64-libinstana_sensor.so

COPY . .
RUN ./mvnw clean package

FROM envoyproxy/envoy:v1.21-latest

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
COPY --from=evnoy-tracing-server-app-build /opt/server-app/${jar_file} ./app.jar
COPY --from=evnoy-tracing-server-app-build /opt/server-app/libinstana_sensor.so ./

COPY start-server-app.sh envoy-server-app.yaml ./
ENTRYPOINT ["./start-server-app.sh"]

CMD ["java","-jar","app.jar"]
