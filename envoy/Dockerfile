# Original from envoyproject/envoy:examples/front-proxy/Dockerfile-frontenvoy
FROM envoyproxy/envoy:ff857396dc6e8c9a94c547bf080ecf6eaa38e333

RUN set -x \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
              curl apt-transport-https iproute2

ARG sensor_version=0.5.0
ARG agent_key

ENV INSTANA_AGENT_KEY=${agent_key}
ENV INSTANA_SENSOR_VERSION=${sensor_version}

# Download extension from Artifactory
ADD https://_:${INSTANA_AGENT_KEY}@artifact-public.instana.io/artifactory/shared/com/instana/libenvoy_sensor/${INSTANA_SENSOR_VERSION}/libenvoy_sensor-${INSTANA_SENSOR_VERSION}.so /usr/local/lib/libinstana_sensor.so
RUN chmod 777 /usr/local/lib/libinstana_sensor.so

ADD ./start-gateway.sh /usr/local/bin/start-gateway.sh
RUN chmod u+x /usr/local/bin/start-gateway.sh

ENTRYPOINT /usr/local/bin/start-gateway.sh
