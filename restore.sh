#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 dir malicious_dir"
    exit 1
fi

DIR=$1
MAL=$2

while true; do
    if [ -z "$(ls "$MAL")" ]; then
        echo "No malicious files to review."
        exit 0
    fi

    # numbered list
    ls "$MAL" | nl -w1 -s") "

    read -p "Pick a file number: " num || exit 0
    # must be a number that matches a line in the list
    name=""
    if [[ "$num" =~ ^[0-9]+$ ]]; then
        name=$(ls "$MAL" | sed -n "${num}p" 2>/dev/null)
    fi
    if [ -z "$name" ]; then
        echo "Invalid number."
        continue
    fi

    echo "1) Restore  2) Delete permanently  3) Leave it"
    read -p "Choice: " choice || exit 0

    if [ "$choice" = "1" ]; then
        if [ -e "$DIR/$name" ]; then
            echo "$name already exists in $DIR, not restoring."
        elif mv "$MAL/$name" "$DIR/$name"; then
            echo "$name" >> whitelist.txt
            echo "Restored $name to $DIR."
        fi
    elif [ "$choice" = "2" ]; then
        rm "$MAL/$name"
        echo "$name permanently deleted."
    elif [ "$choice" = "3" ]; then
        echo "Left $name in quarantine."
    else
        echo "Invalid choice."
    fi
done
