
## Example

    docker build . -t cidrproxy:latest
    docker run -p 8001:8001 --env UPSTREAM_CIDR=192.168.0.0/28 cidrproxy:latest

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

