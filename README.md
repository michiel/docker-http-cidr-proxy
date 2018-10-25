

## Variables


| Name             | Default          | Description |
|------------------|------------------|-------------|
| LISTENER\_PORT   | 8088             | Port to receive connections on |
| UPSTREAM\_PORT   | 80               | Port to connect upstream       |
| ADMIN\_PORT      | 8001             | Port to run envoy admin UI on  |
| UPSTREAM\_CIDR   | None             | CIDR range to configure for upstream |
| UPSTREAM\_LB\_POLICY| round\_robin  | REQUIRED - Valid envoy load-balancing policy (round\_robin, random, etc) |
| UPSTREAM\_CONNECT\_TIMEOUT| 0.1s     | Upstream timeout |
| UPSTREAM\_SET\_TLS| None            | Set to true to enable TLS context creation |
| TLS\_CRT\_FILE | None               | Location of CRT file |
| TLS\_KEY\_FILE | None               | Location of KEY file |
| DEBUG          | None               | Set to true to dump generated config to STDOUT |




## Example

    docker build .
    docker run -p 8001:8001 --env UPSTREAM_CIDR=192.168.0.0/28 $IMAGE

    LISTENER_PORT is 8088
    UPSTREAM_PORT is 80
    ADMIN_PORT is 8001
    Using template /tools/front-envoy.yaml
    Output to file /tmp/front-envoy.yaml
    UPSTREAM_CIDR is set to '192.168.0.0/28'
    UPSTREAM_CIDR will expand to 16 addresses :
         192.168.0.0
         192.168.0.1
         192.168.0.2
         192.168.0.3
         192.168.0.4
         192.168.0.5
         192.168.0.6
         192.168.0.7
         192.168.0.8
         192.168.0.9
         192.168.0.10
         192.168.0.11
         192.168.0.12
         192.168.0.13
         192.168.0.14
         192.168.0.15
    [2018-10-25 11:07:52.050][204][info][main] source/server/server.cc:202] initializing epoch 

Open [http://localhost:8001](http://localhost:8001) for admin UI


    docker run -p 8001:8001 --env UPSTREAM_CIDR=192.168.0.0/28 --env DUMP_GENERATED_CONFIG=1 --env DEBUG=true --env UPSTREAM_SET_TLS=1 --env TLS_CRT_FILE=/tmp/xxx --env TLS_KEY_FILE=/tmp/xasd cidrproxy:latest


