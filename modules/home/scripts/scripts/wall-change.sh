if (( $# != 1 )) || [[ ! -f "$1" ]]; then
  echo "Usage: wall-change <wallpaper-file>" >&2
  exit 2
fi

mapfile -t old_pids < <(pgrep -x swaybg || true)

swaybg -m fill -i "$1" &
new_pid=$!

for pid in "${old_pids[@]}"; do
  kill "$pid" 2>/dev/null || true
done

disown "$new_pid" 2>/dev/null || true
