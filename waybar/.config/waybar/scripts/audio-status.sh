#!/bin/sh

DEFAULT=$(pactl get-default-sink)
VOL=$(pactl get-sink-volume "$DEFAULT" | awk '{print $5}' | head -n1)
MUTED=$(pactl get-sink-mute "$DEFAULT" | awk '{print $2}')
DEVICE="$DEFAULT"

ICON=""
CLASS=""

if [ "$MUTED" = "yes" ]; then
    ICON=""
    CLASS="muted"
elif [ "${VOL%\%}" -gt 70 ]; then
    ICON=""
elif [ "${VOL%\%}" -gt 30 ]; then
    ICON=""
fi

if [ -n "$CLASS" ]; then
    echo "{\"text\": \"$VOL $ICON\", \"tooltip\": \"$DEVICE\", \"class\": \"$CLASS\"}"
else
    echo "{\"text\": \"$VOL $ICON\", \"tooltip\": \"$DEVICE\"}"
fi
