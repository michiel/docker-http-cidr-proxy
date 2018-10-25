FROM envoyproxy/envoy-alpine:v1.8.0

RUN apk add --no-cache bash
RUN mkdir /tools
COPY resource/cidr.sh /tools
COPY resource/run.sh /tools
CMD /usr/local/bin/envoy --v2-config-only -l $loglevel -c /etc/envoy/envoy.yaml


