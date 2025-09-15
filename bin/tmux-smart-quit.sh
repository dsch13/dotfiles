#!/usr/bin/env bash
set -euo pipefail

curr_session=$(tmux display -p '#S')
win_panes=$(tmux display -p '#{window_panes}')
sess_wins=$(tmux display -p '#{session_windows}')
session_count=$(tmux list-sessions 2>/dev/null | wc -l | tr -d ' ')

if [ "$win_panes" -gt 1 ]; then
  tmux kill-pane
elif [ "$sess_wins" -gt 1 ]; then
  tmux kill-pane
else
  if [ "$session_count" -gt 1 ]; then
    last=$(tmux display -p '#{client_last_session}')
    if [ -n "${last:-}" ] && tmux has-session -t "$last" 2>/dev/null; then
      target="$last"
    else
      target=$(tmux list-sessions -F '#S' | grep -v "^$curr_session$" | head -n1)
    fi
    tmux switch-client -t "$target"
    tmux kill-session -t "$curr_session"
  else
    tmux kill-session -t "$curr_session"
  fi
fi
