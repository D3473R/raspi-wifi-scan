#!/bin/bash

display_usage() {
    echo "This script must be run with super-user privileges."
}

if [[ ( $# == "--help") ||  $# == "-h" ]]
then
    display_usage
    exit 0
fi

if [[ "$EUID" -ne 0 ]]; then
    display_usage
    exit 1
fi

printf "%-20s%-25s%-20s\n" "mac" "essid" "hex"
iwlist scan 2>/dev/null |
while IFS= read -r line; do
    [[ "$line" =~ Address ]] && mac=${line##*ss: }
    [[ "$line" =~ ESSID ]] && {
        essid=${line##*ID:}
        essid=$(echo -en "${essid//\"}")
        hex=$(echo -n $essid | xxd -p | tr a-z A-Z)
        printf "%-20s%-25s%-20s\n" "$mac" "\"$essid\"" "$hex"
    }
done
