#!/bin/bash

export LISTENER_PORT="${LISTENER_PORT:-8088}"
export UPSTREAM_PORT="${UPSTREAM_PORT:-80}"

echo "LISTENER_PORT is $LISTENER_PORT"
echo "UPSTREAM_PORT is $UPSTREAM_PORT"

# https://stackoverflow.com/questions/10107459/replace-a-word-with-multiple-lines-using-sed
if [ -z ${UPSTREAM_CIDR+x} ];
then
  echo "UPSTREAM_CIDR is unset - ABORTING";
  exit -1;
else
  echo "UPSTREAM_CIDR is set to '$UPSTREAM_CIDR'";
fi

echo "UPSTREAM_CIDR will expand to :"
./resource/cidr.sh $UPSTREAM_CIDR

# awk -v r="$DATA" '{gsub(/_data_/,r)}1' /etc/envoy/front-envoy.yaml
