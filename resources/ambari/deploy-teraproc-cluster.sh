#!/bin/bash

source "/vagrant/scripts/common.sh"

: ${AMBARI_HOST:=http://node1}
: ${EXPECTED_HOST_COUNT:=6}
: ${SLEEP:=2}
: ${DEBUG:=1}
: ${AMBARI_USERNAME:=admin}
: ${AMBARI_PASSWORD:=admin}
: ${BLUEPRINT:=hdp-teraproc-default}
: ${CLUSTER:=TeraprocTestCluster}
: ${BLUEPRINT_FILE:=teraproc-default-blueprint.json}
: ${CLUSTER_FILE:=TeraprocTestCluster.json}

debug() {
  [ $DEBUG -gt 0 ] && echo [DEBUG] "$@" 1>&2
}

get-connected-hosts() {
  CONNECTED_HOSTS=$(
  curl \
    --connect-timeout 2 \
    -u ${AMBARI_USERNAME}:${AMBARI_PASSWORD} \
    -H 'Accept: text/plain' \
    $AMBARI_HOST:8080/api/v1/hosts \
    2>/dev/null \
    | grep host_name \
    | wc -l
  )
  debug connected hosts: $CONNECTED_HOSTS
  echo $CONNECTED_HOSTS
}

get-server-state() {
  curl \
    --connect-timeout 2 \
    -u ${AMBARI_USERNAME}:${AMBARI_PASSWORD} \
    -H 'Accept: text/plain' \
    $AMBARI_HOST:8080/api/v1/check \
    2>/dev/null
}

post-blueprint() {
  curl \
    --connect-timeout 2 \
    -H "X-Requested-By: ambari" \
	-X POST \
	-u ${AMBARI_USERNAME}:${AMBARI_PASSWORD} \
	$AMBARI_HOST:8080/api/v1/blueprints/${BLUEPRINT} -d @${BLUEPRINT_FILE} 2>/dev/null
}

create-cluster() {
  curl \
  -H "X-Requested-By: ambari" \
  -X POST \
  -u ${AMBARI_USERNAME}:${AMBARI_PASSWORD} \
  $AMBARI_HOST:8080/api/v1/clusters/${CLUSTER} -d @${CLUSTER_FILE} 2>/dev/null
}

debug waits for ambari server: $AMBARI_HOST RUNNING ...
while ! get-server-state | grep RUNNING &>/dev/null ; do
  [ $DEBUG -gt 0 ] && echo -n .
  sleep $SLEEP
done

debug waits until $EXPECTED_HOST_COUNT hosts connected to server ...
while [ $(get-connected-hosts) -lt $EXPECTED_HOST_COUNT ] ; do
  sleep $SLEEP
done

post-blueprint

if create-cluster | grep InProgress &>/dev/null ; then
  echo 
  echo ===============================================================
  echo Ambari has started deploying the HDP cluster. Please log on to
  echo http://10.211.55.101:8080
  echo to view the progress
  echo ===============================================================  
  echo   
fi


