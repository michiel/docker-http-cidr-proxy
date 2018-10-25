#!/bin/bash

export LISTENER_PORT="${LISTENER_PORT:-8088}"
export UPSTREAM_PORT="${UPSTREAM_PORT:-80}"
export UPSTREAM_LB_POLICY="${UPSTREAM_LB_POLICY:-round_robin}"
export UPSTREAM_CONNECT_TIMEOUT="${UPSTREAM_CONNECT_TIMEOUT:-0.1s}"
export ADMIN_PORT="${ADMIN_PORT:-8001}"

export TARGET="${TARGET:-/tmp/front-envoy.yaml}"
export TEMPLATE="${TEMPLATE:-/tools/front-envoy.yaml}"

CIDR_SCRIPT=/tools/cidr.sh

echo "ADMIN_PORT is $ADMIN_PORT"
echo "Using template $TEMPLATE"
echo "Output to file $TARGET"
echo "LISTENER_PORT is $LISTENER_PORT"
echo "UPSTREAM_PORT is $UPSTREAM_PORT"
echo "UPSTREAM_LB_POLICY is $UPSTREAM_LB_POLICY"
echo "UPSTREAM_CONNECT_TIMEOUT is $UPSTREAM_CONNECT_TIMEOUT"

cp $TEMPLATE $TARGET

sed -i "s/LISTENER_PORT/$LISTENER_PORT/" $TARGET
sed -i "s/ADMIN_PORT/$ADMIN_PORT/" $TARGET
sed -i "s/UPSTREAM_LB_POLICY/$UPSTREAM_LB_POLICY/" $TARGET
sed -i "s/UPSTREAM_CONNECT_TIMEOUT/$UPSTREAM_CONNECT_TIMEOUT/" $TARGET

if [ -z ${UPSTREAM_CIDR+x} ];
then
  echo "UPSTREAM_CIDR is unset - ABORTING";
  exit -1;
else
  echo "UPSTREAM_CIDR is set to '$UPSTREAM_CIDR'";
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "Template file $TEMPLATE does not exist - ABORTING";
  exit -1;
fi

IP_COUNT=`$CIDR_SCRIPT $UPSTREAM_CIDR | wc -l`
IP_LIST=`$CIDR_SCRIPT $UPSTREAM_CIDR`

echo "UPSTREAM_CIDR will expand to $IP_COUNT addresses :"

$CIDR_SCRIPT $UPSTREAM_CIDR  | sed 's/^/   - /'

if [[ $UPSTREAM_SET_TLS = "true" ]];
then
  echo "UPSTREAM_SET_TLS, creating context";

  if [ -z ${TLS_CRT_FILE+x} ]; then
    echo "UPSTREAM_SET_TLS, but no TLS_CRT_FILE set - ABORTING";
    exit -1;
  fi

  if [ -z ${TLS_KEY_FILE+x} ]; then
    echo "UPSTREAM_SET_TLS, but no TLS_KEY_FILE set - ABORTING";
    exit -1;
  fi

  echo "    tls_context:" >> $TARGET
  echo "      common_tls_context:" >> $TARGET
  echo "        tls_certificates:" >> $TARGET
  echo "          - certificate_chain:" >> $TARGET
  echo "              filename: \"$TLS_CRT_FILE\"" >> $TARGET
  echo "            private_key:" >> $TARGET
  echo "              filename: \"$TLS_KEY_FILE\"" >> $TARGET
else
  echo "No UPSTREAM_SET_TLS, keeping context empty";
  echo "    tls_context: {}" >> $TARGET
fi

echo "    hosts:" >> $TARGET
for ip in $IP_LIST;
do
  echo "    - socket_address:" >> $TARGET
  echo "        address: $ip" >> $TARGET
  echo "        port_value: $UPSTREAM_PORT" >> $TARGET
done;

if [[ $DEBUG = "true" ]];
then
  echo "Attempting to start envoy with config .."
  echo ">>>> START CONFIG >>>>"
  cat $TARGET  | sed 's/^/     /'
  echo "<<<< END CONFIG <<<<" 
fi

/usr/local/bin/envoy --v2-config-only -l $loglevel -c $TARGET

