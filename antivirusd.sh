#!/bin/bash
# flags and keywords

EXTENSIONS="exe bat vbs scr ps1"
KEYWORDS="virus|trojan|malware|worm|ransomware"

if [ $# -ne 3 ]; then
    echo "Usage: $0 dir malicious_dir interval-secs"
    exit 1
fi

DIR=$1
MAL=$2
INTERVAL=$3

mkdir -p "$MAL"

scan() {
    for f in "$DIR"/*; do
        [ -f "$f" ] || continue
        name=$(basename "$f")

        # skip files that were restored before
        if grep -qxF "$name" whitelist.txt 2>/dev/null; then
            continue
        fi

        bad=0
        for e in $EXTENSIONS; do
            if [[ "$name" == *.$e ]]; then
                bad=1
            fi
        done
        if grep -qiE "$KEYWORDS" "$f"; then
            bad=1
        fi

        if [ $bad -eq 1 ]; then
            # only delete the original if the copy worked
            if cp "$f" "$MAL/$name"; then
                echo "$f is malicious and it is DELETED"
                rm "$f"
            fi
        fi
    done
}

# first run: scan right away, then take the first snapshot
scan
ls -l "$DIR" > directory-info.last

while true; do
    sleep "$INTERVAL"
    ls -l "$DIR" > directory-info.new
    if ! cmp -s directory-info.last directory-info.new; then
        scan
        cp directory-info.new directory-info.last
    fi
done
