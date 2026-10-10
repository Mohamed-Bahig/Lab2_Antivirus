#!/bin/bash
EXTENSIONS="exe bat vbs scr ps1"
KEYWORDS="virus|trojan|malware|worm|ransomware"

if [ $# -ne 2 ]; then
    echo "Usage: $0 dir malicious_dir"
    exit 1
fi

DIR=$1
MAL=$2

mkdir -p "$MAL"

# cron starts in the home folder, so go to the script's folder
# (the snapshot files and whitelist.txt are kept here)
cd "$(dirname "$0")"

scan() {
    for f in "$DIR"/*; do
        [ -f "$f" ] || continue
        name=$(basename "$f")

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
            if cp "$f" "$MAL/$name"; then
                echo "$f is malicious and it is DELETED"
                rm "$f"
            fi
        fi
    done
}

ls -l "$DIR" > directory-info.new
if ! cmp -s directory-info.last directory-info.new; then
    scan
    cp directory-info.new directory-info.last
fi

