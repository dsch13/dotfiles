#!/bin/bash

BACKUP_FILE=".repo_states_backup"
LOG_FILE="repo_script.log"
CHECK_MODE=false

if [ "$1" == "--check" ] || [ "$1" == "-c" ]; then
    CHECK_MODE=true
fi

> "$BACKUP_FILE"
> "$LOG_FILE"

log() {
    echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"
}

switched_count=0
stashed_count=0
repo_count=0

for dir in */; do
    if [ -d "$dir/.git" ]; then
        repo_count=$((repo_count + 1))
        cd "$dir" || continue

        current_branch=$(git rev-parse --abbrev-ref HEAD)
        changes=$(git status --porcelain)

        echo "$dir $current_branch" >> "../$BACKUP_FILE"

        if [ -n "$changes" ]; then
            stashed_count=$((stashed_count + 1))
            echo "  - Would stash changes in $dir"
            if [ "$CHECK_MODE" = false ]; then
                git stash push -u -m "auto-stash-for-script" >> "../$LOG_FILE" 2>&1
                echo "  - STASHED" >> "../$BACKUP_FILE"
            fi
        fi

        if [ "$current_branch" != "master" ]; then
            switched_count=$((switched_count + 1))
            echo "  - Would switch $dir from $current_branch to master"
            [ "$CHECK_MODE" = false ] && git checkout master >> "../$LOG_FILE" 2>&1
        fi

        [ "$CHECK_MODE" = false ] && git pull origin master >> "../$LOG_FILE" 2>&1

        cd ..
    fi
done

if [ "$CHECK_MODE" = true ]; then
    echo
    echo "Summary: $repo_count repos checked"
    echo "         $switched_count branches will be switched"
    echo "         $stashed_count repos will be stashed"
fi
