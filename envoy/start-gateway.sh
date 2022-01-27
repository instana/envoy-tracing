#!/bin/sh
/usr/local/bin/envoy -c /opt/envoy/envoy-gateway.yaml --service-cluster envoy-gateway
