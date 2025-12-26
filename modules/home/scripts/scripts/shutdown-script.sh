#!/usr/bin/env bash
set -euo pipefail

respond="$(
  printf "Shutdown\nRestart\nCancel\n" |
    fuzzel --dmenu --lines=3 --width=10 --prompt=''
)"

case "$respond" in
Shutdown)
  echo "shutdown"
  shutdown now
  ;;
Restart)
  echo "restart"
  reboot
  ;;
"" | Cancel)
  notify-send "cancel shutdown"
  ;;
esac
