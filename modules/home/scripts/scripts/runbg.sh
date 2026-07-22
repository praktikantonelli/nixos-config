if (( $# == 0 )); then
  echo "$(basename "$0"): missing command" >&2
  exit 1
fi

if ! prog="$(command -v "$1")"; then
  echo "$(basename "$0"): unknown command: $1" >&2
  exit 1
fi

shift
tty -s && exec </dev/null
tty -s <&1 && exec >/dev/null
tty -s <&2 && exec 2>&1
"$prog" "$@" &
