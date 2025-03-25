#!/bin/bash

SESSION_NAME="ghostty"
tmux=/opt/homebrew/bin/tmux

# Check if the session already exists
$tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? -eq 0 ]; then
  # If the session exists, reattach to it
  $tmux attach -t $SESSION_NAME
else
  # If the session doesn't exist, start a new one
  $tmux new -s $SESSION_NAME -d
  $tmux attach -t $SESSION_NAME
fi
