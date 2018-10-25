FROM envoyproxy/envoy-alpine:v1.8.0

RUN apk add --no-cache bash
RUN mkdir /tools
COPY resource/cidr.sh /tools
COPY resource/run.sh /tools
COPY resource/front-envoy.yaml /tools

ENV DEBUG false
ENV LISTENER_PORT 8088
ENV ADMIN_PORT 8001
ENV UPSTREAM_PORT 80
ENV UPSTREAM_LB_POLICY round_robin
ENV UPSTREAM_CONNECT_TIMEOUT 0.1s

ENV TEMPLATE /tools/front-envoy.yaml
ENV TARGET /tmp/front-envoy.yaml

CMD /tools/run.sh


