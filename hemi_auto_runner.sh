#!/bin/bash

while true; do
	max_retries=10
	retry_count=0
	set_fee=0
	CONST_FEE=1500
	timeout_duration="8h"

	echo "Trying to fetch recommanded fees, max retries $max_retries..."

	while [ $retry_count -lt $max_retries ]; do
	  set_fee=$(curl -m 5 -sSL "https://mempool.space/testnet/api/v1/fees/recommended" | jq .fastestFee)

	  if [ $? -eq 0 ] && [ -n "$set_fee" ] && [ "$set_fee" != "null" ]; then
	    echo "Request was successful, setting fees to $set_fee"
	    break
	  else
	    echo "Request failed. Retrying..."
	    retry_count=$((retry_count + 1))
	    sleep 2
	  fi
	done

	if [ $retry_count -eq $max_retries ]; then
	  echo "Failed to fetch fees after $max_retries retries. Defaulting to $CONST_FEE"
	  set_fee=$CONST_FEE
	fi


        # if [ -z "$set_fee" ]; then
        #     echo "fees variable is empty, defaulting to $CONST_FEE"
        #     set_fee=$CONST_FEE
        # fi

        # set_fee=$(echo "$set_fee * 1.5" | bc -l)

        # set_fee=$(printf "%.0f" "$set_fee")

        export POPM_STATIC_FEE=$set_fee

        timeout --kill-after=$timeout_duration $timeout_duration ./popmd

        sleep 5
done

