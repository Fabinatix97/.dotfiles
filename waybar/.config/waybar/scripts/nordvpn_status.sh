#!/bin/sh

if ! nordvpn account &>/dev/null; then
    echo "󰍂"
    exit 0
fi

STATUS=$(nordvpn status | grep -i "Status" | awk '{print $2}')

if [[ "$STATUS" == "Connected" ]]; then
    echo ""
else
    echo ""
fi
