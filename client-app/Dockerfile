FROM openjdk:11-jdk-slim AS envoy-tracing-client-app-build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
    curl \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/client-app/
COPY ./ ./
RUN ./mvnw clean package

FROM openjdk:11-jre-slim

VOLUME /tmp
WORKDIR /opt/client-app/
ARG JAR_FILE=target/client-app-1.0.0.RELEASE.jar
COPY --from=envoy-tracing-client-app-build /opt/client-app/${JAR_FILE} ./app.jar

CMD ["java","-jar","app.jar"]
