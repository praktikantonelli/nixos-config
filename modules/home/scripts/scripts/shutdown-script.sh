respond="$(
  printf "Shutdown\nRestart\nCancel\n" |
    fuzzel --dmenu --lines=3 --width=10 --prompt=''
)"

case "$respond" in
Shutdown)
  systemctl poweroff
  ;;
Restart)
  systemctl reboot
  ;;
"" | Cancel)
  notify-send "cancel shutdown"
  ;;
esac
