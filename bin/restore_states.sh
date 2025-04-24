#!/bin/bash

BACKUP_FILE=".repo_states_backup"
LOG_FILE="repo_script.log"
CHECK_MODE=false

if [ "$1" == "--check" ] || [ "$1" == "-c" ]; then
    CHECK_MODE=true
fi

log() {
    echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"
}

if [ ! -f "$BACKUP_FILE" ]; then
    echo "No backup state found."
    log "No backup state found, aborting."
    exit 1
fi

restored_count=0
stash_applied_count=0

while read -r line; do
    set -- $line
    dir=$1
    branch=$2
    stashed=""

    if [ $# -eq 3 ]; then
        stashed=$3
    fi

    if [ -d "$dir/.git" ]; then
        restored_count=$((restored_count + 1))
        echo "  - Would restore $dir to $branch"

        if [ "$stashed" = "STASHED" ]; then
            stash_applied_count=$((stash_applied_count + 1))
            echo "    - Would apply stash"
        fi

        if [ "$CHECK_MODE" = false ]; then
            cd "$dir" || continue
            git checkout "$branch" >> "../$LOG_FILE" 2>&1
            [ "$stashed" = "STASHED" ] && git stash pop >> "../$LOG_FILE" 2>&1
            cd ..
        fi
    fi
done < "$BACKUP_FILE"

if [ "$CHECK_MODE" = true ]; then
    echo
    echo "Summary: $restored_count repos will be restored"
    echo "         $stash_applied_count stashes will be applied"
else
    log "Cleanup: Removing $BACKUP_FILE"
    rm "$BACKUP_FILE"
fi
