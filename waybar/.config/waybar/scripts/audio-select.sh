#!/bin/sh

echo "Select audio output device"
echo "=========================="
echo

mapfile -t sinks < <(pactl list short sinks)

[ "${#sinks[@]}" -eq 0 ] && { echo "No audio sinks found."; exit 1; }

ids=()
for i in "${!sinks[@]}"; do
    line="${sinks[$i]}"
    id=$(echo "$line" | awk '{print $1}')
    name=$(echo "$line" | awk '{print $2}')
    printf "%d) %s\n" "$((i+1))" "$name"
    ids[$i]="$id"
done

echo

while true; do
    read -rp "Enter number: " choice

    if ! [ "$choice" -eq "$choice" ] 2>/dev/null; then
        echo "Invalid input. Please enter a number."
        continue
    fi

    index=$((choice-1))

    if [ "$index" -ge 0 ] && [ "$index" -lt "${#ids[@]}" ]; then
        pactl set-default-sink "${ids[$index]}"
        echo "Switched audio output to ${ids[$index]}."
        exit 0
    else
        echo "Number out of range. Try again."
    fi
done