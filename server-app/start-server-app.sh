#!/bin/bash

set +x

(exec "$@" &)
/usr/local/bin/envoy -c envoy-server-app.yaml --service-cluster "server_app"
