# Instana Envoy Tracing Demo

This repository contains a technology preview for Instana's [Envoy](https://www.envoyproxy.io/) tracing functionality.

## Disclaimer

*Instana Envoy tracing is currently a technology preview.*

We reserve ourselves the right to make it better and easier before releasing the functionality for General Availability.

## Supported Versions

The distributed tracing is compatible with Envoy Proxy versions 1.12 and 1.13. It is currently incompatible with versions 1.14 and above.

## Prerequisites

A `docker-compose` installation running on your machine. This demo has been created and tested on Mac OS X with `docker-compose` and `docker-machine`.

## Configure

Create a `.env` file in the root of the checked-out version of this repository and enter the following text, with the values adjusted as necessary:

```text
agent_key=<TODO FILL UP>
agent_endpoint=<local ip or remote host; e.g., saas-us-west-2.instana.io>
agent_endpoint_port=<443 already set as default; or 4443 for local>
agent_zone=<name of the zone for the agent; default: envoy-tracing-demo>
```

## Build

```bash
docker-compose build
```

## Launch

```bash
docker-compose up
```

This will build and launch

- `client-app` service, a simple Spring Boot application that issues a request every second to the ...
- `envoy` service, which routes all incoming requests to the ...
- `server-app` service, a simple Spring Boot application that returns `200` to any HTTP request.

After the agent is bootstrapped and starts accepting spans from Envoy, the resulting traces in the Analyze view will look like the following:

![Demo traces in the Analyze view](images/trace-view.png)

## Setup an Application Perspective for the Demo

The simplest way is just to assign to the agent a unique zone (the `docker-compose.yml` file comes with the pre-defined `envoy-tracing-demo`), and simply create the application to contain all calls with the `agent.zone` tag to have the value `envoy-tracing-demo`.

## Released Binaries

**Link**: https://artifact-public.instana.io/artifactory/shared/com/instana/libinstana_sensor/<br/>
**Credentials**: `_:${agent_key}`

Only `linux-amd64-libinstana_sensor.so` is required on Linux distributions using glibc. For musl libc, there is the module `linux-amd64-musl-libinstana_sensor.so`.

Since version 0.6.0, there are additional modules for NGINX tracing as NGINX does not come with OpenTracing support by default. Those can be ignored for Envoy tracing.

## Release History

### 1.1.0 (2020-07-31)

   * fixed the agent discovery if `/proc/$pid/sched` (`CONFIG_SCHED_DEBUG`) is not available

### 1.0.0 (2020-06-26)

   * added support for secrets in URLs configured by the agent
   * added support for hiding synthetic calls

### 0.8.0 (2020-03-30)

   * made MaxBufferedSpans configurable (default `1000`)
      * added `max_buffered_spans` JSON config entry
   * added EUM handling for NGINX tracing only
   * handling correlation part of extended `X-INSTANA-L` header for mobile EUM
   * HTTP extra headers are captured also in root spans
      * requires an Instana backend update (v174) for those heads to be matched by the `call.http.header` filter

### 0.7.0 (2020-01-02)

   * logging `libinstana_sensor` version upon module load
      * information gathering for better support
   * added timestamps and prefix "[lis]" to log messages for better debugging
   * added pid to log messages
   * enforcing IPv4 in agent host name resolution
      * avoiding failure due to IPv6 address for same host name
   * implemented a new discovery request format
      * requiring the C++ sensor 1.1.0 agent part for faster agent connection
   * reworked the agent connection/discovery to quickly connect
      * if no agent host is configured, then the gateway is checked first
   * only logging an error if connections to all agent host candidates fail
      * converted misleading error message upon failure of first candidate
   * increased span flushing interval from 5s to 1s

### 0.6.0 (2019-09-06)

   * no changes relevant to Envoy tracing

### 0.5.4 (2019-03-20)

   * initial public release