#!/bin/bash

export LISTENER_PORT="${LISTENER_PORT:-8088}"
export UPSTREAM_PORT="${UPSTREAM_PORT:-80}"
export ADMIN_PORT="${ADMIN_PORT:-8001}"

export TARGET="${TARGET:-/tmp/front-envoy.yaml}"
export TEMPLATE="${TEMPLATE:-/tools/front-envoy.yaml}"

CIDR_SCRIPT=/tools/cidr.sh

echo "LISTENER_PORT is $LISTENER_PORT"
echo "UPSTREAM_PORT is $UPSTREAM_PORT"
echo "ADMIN_PORT is $ADMIN_PORT"
echo "Using template $TEMPLATE"
echo "Output to file $TARGET"

cp $TEMPLATE $TARGET

sed -i "s/LISTENER_PORT/$LISTENER_PORT/" $TARGET
sed -i "s/ADMIN_PORT/$ADMIN_PORT/" $TARGET

# https://stackoverflow.com/questions/10107459/replace-a-word-with-multiple-lines-using-sed
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

# ./resource/cidr.sh $UPSTREAM_CIDR  | sed 's/^/     /'
$CIDR_SCRIPT $UPSTREAM_CIDR  | sed 's/^/     /'

for ip in $IP_LIST;
do
  echo "    - socket_address:" >> $TARGET
  echo "        address: $ip" >> $TARGET
  echo "        port_value: $UPSTREAM_PORT" >> $TARGET
done;

/usr/local/bin/envoy --v2-config-only -l $loglevel -c $TARGET

