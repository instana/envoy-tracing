#!/bin/sh
/usr/local/bin/envoy -c /etc/envoy-gateway.yaml --service-cluster envoy-gateway
