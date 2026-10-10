#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: ./antivirusd.sh dir malicious_dir interval-secs" >&2
    exit 1
fi
dir="$1"
malicious_dir="$2"
interval="$3"

# flags
EXTENSIONS=(.exe .bat .vbs .scr .ps1)
KEYWORDS=(virus trojan malware worm ransomware)
