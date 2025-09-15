#!/usr/bin/env bash
set -euo pipefail

# Figure out the currently attached client's session (if any).
# If no attached client, exit quietly.
if ! curr_session=$(tmux display -p '#S' 2>/dev/null); then
  exit 0
fi

# Count panes & windows in the (current) session.
# If these display commands fail, just bail.
if ! panes=$(tmux display -p '#{window_panes}' 2>/dev/null); then exit 0; fi
if ! wins=$(tmux display -p '#{session_windows}' 2>/dev/null); then exit 0; fi

# We only care when we just hit the last pane of the last window.
if [ "${panes}" -le 1 ] && [ "${wins}" -le 1 ]; then
  # More than one session on the server?
  if [ "$(tmux list-sessions 2>/dev/null | wc -l | tr -d ' ')" -gt 1 ]; then
    # Prefer the last session this client used; fall back to "next" session.
    last=$(tmux display -p '#{client_last_session}' 2>/dev/null || true)
    if [ -n "${last:-}" ] && tmux has-session -t "$last" 2>/dev/null; then
      tmux switch-client -t "$last"
    else
      tmux switch-client -n
    fi
    # Kill the now-empty session if it still exists.
    tmux has-session -t "$curr_session" 2>/dev/null && tmux kill-session -t "$curr_session"
  else
    # No other session to jump to; just kill this one (keeps behavior consistent).
    tmux kill-session -t "$curr_session" 2>/dev/null || true
  fi
fi
