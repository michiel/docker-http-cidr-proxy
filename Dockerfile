FROM envoyproxy/envoy-alpine:v1.8.0

RUN apk add --no-cache bash
RUN mkdir /tools
COPY resource/cidr.sh /tools
COPY resource/run.sh /tools
COPY resource/front-envoy.yaml /tools

ENV LISTENER_PORT 8088
ENV UPSTREAM_PORT 80
ENV ADMIN_PORT 8001

ENV TEMPLATE /tools/front-envoy.yaml
ENV TARGET /tmp/front-envoy.yaml

CMD /tools/run.sh


