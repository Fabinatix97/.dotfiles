#!/bin/sh

echo "Checking if logged in to NordVPN..."
login_check_output=$(nordvpn account 2>&1)
if echo "$login_check_output" | grep -q "You are not logged in"; then
    echo "You are not logged in."
    echo "Logging in..."
    login_output=$(nordvpn login 2>&1)

    echo "Extracting login URL..."
    login_url=$(echo "$login_output" | grep -oP 'https?://[^\s]+' | head -n1)

    if [ -n "$login_url" ]; then
        echo "Opening login URL in browser:"
        echo "$login_url"
        xdg-open "$login_url"
    else
        echo "Could not find login URL in login output!"
    fi

    echo "Please complete login in the browser, then press Enter here to continue."
    read
else
    echo "Logged in successfully."
    echo "Checking status of NordVPN..."
    status_output=$(nordvpn status | grep '^Status:' | cut -d' ' -f2)
    echo "$status_output"

    if echo "$status_output" | grep -q "Connected"; then
        echo "Disconnecting from NordVPN..."
        nordvpn disconnect
    else
        echo "Available NordVPN countries:"
        nordvpn countries
        echo

        read -rp "Enter country to connect to: " COUNTRY
        echo

        echo "Connecting to NordVPN ($COUNTRY)..."
        nordvpn connect "$COUNTRY" 2>&1
    fi
fi
