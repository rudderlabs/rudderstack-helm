#!/bin/sh
START=$(date +%s.%N)

# Install JQ
JQ=/usr/bin/jq
curl -sLo $JQ https://stedolan.github.io/jq/download/linux64/jq
chmod +x $JQ

# Extract source IDs
SOURCE_IDS=$(more $RSERVER_BACKEND_CONFIG_CONFIG_JSONPATH | jq -r .sources[].id)
STATSD_PREFIX="rudder_server_pre_stop"

# Emit Start datum to Telegraf
echo "${STATSD_PREFIX}_start:1|c" | nc -w 1 -u localhost 8125

# Check pending events per Source ID
HAS_PENDING_EVENTS=true
while $HAS_PENDING_EVENTS ; do
    TOTAL_PENDING_EVENTS=0
    echo "1. Checking pending events...."
    echo "${STATSD_PREFIX}_check:1|c" | nc -w 1 -u localhost 8125

    for source_id in $SOURCE_IDS; do
      PENDING_EVENTS=$(curl -s --request POST --url http://localhost:8080/v1/pending-events \
           -u ${source_id}:potato --header 'Content-Type: application/json' \
           --data "{\"source_id\": \"${source_id}\"}" | jq .pending_events)
      echo "2. Pending $PENDING_EVENTS events for Source [$source_id]"
      TOTAL_PENDING_EVENTS=$(( $TOTAL_PENDING_EVENTS + $PENDING_EVENTS ))
    done

    echo "3. Checking result..."
    echo "${STATSD_PREFIX}_pending_events:$TOTAL_PENDING_EVENTS|g" | nc -w 1 -u localhost 8125
    if [[ ${TOTAL_PENDING_EVENTS} -eq 0 ]]; then
       echo "4. No pending events"
       HAS_PENDING_EVENTS=false
    else
       echo "4. Total pending events: $TOTAL_PENDING_EVENTS"
    fi
    echo "5. Sleeping for 5 seconds..."
    sleep 5s

done

echo "${STATSD_PREFIX}_done:1|c" | nc -w 1 -u localhost 8125
END=$(date +%s.%N)
PRE_STOP_DURATION_SEC=$(echo "$END - $START" | bc)
echo "${STATSD_PREFIX}_time:${PRE_STOP_DURATION_SEC}|ms" | nc -w 1 -u localhost 8125

# Giving time to Telegraf to forward pre-stop metrics
sleep 60s
