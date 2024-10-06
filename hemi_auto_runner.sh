#!/bin/bash

while true; do
        set_fee=$(curl -sSL "https://mempool.space/testnet/api/v1/mining/blocks/fee-rates/1m" | jq '.[-1].avgFee_100')

        if [[ -z "$set_fee" || "$set_fee" == "null" ]]; then
                set_fee=250
        fi

        set_fee=$(echo "$set_fee * 1.5" | bc -l)

        set_fee=$(printf "%.0f" "$set_fee")

        export POPM_STATIC_FEE=$set_fee

        ./popmd

        sleep 5
done
