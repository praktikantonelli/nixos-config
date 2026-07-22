set -euo pipefail

app_name="Recorder"
output_dir="$HOME/Videos"
state_dir="${XDG_RUNTIME_DIR:-/tmp/record-${UID}}/recorder"
recording_file="$state_dir/recording.mp4"
mode_file="$state_dir/mode"
name_file="$state_dir/name"
palette_file="$state_dir/palette.png"
unoptimized_gif="$state_dir/recording-unoptimized.gif"
optimized_gif="$state_dir/recording.gif"

notify() {
  notify-send -a "$app_name" "$1" "$2" -t 5000
}

is_recording() {
  pgrep -x wf-recorder >/dev/null
}

cleanup() {
  rm -f "$recording_file" "$mode_file" "$name_file" "$palette_file" \
    "$unoptimized_gif" "$optimized_gif"
}

choose_save_path() {
  local extension="$1"
  local default_path
  local selected_path

  default_path="$output_dir/$(<"$name_file").$extension"

  selected_path="$(
    zenity \
      --file-selection \
      --save \
      --confirm-overwrite \
      --file-filter="*.$extension" \
      --filename="$default_path" 2>/dev/null || true
  )"

  if [[ -z "$selected_path" ]]; then
    selected_path="$default_path"
  fi

  if [[ "$selected_path" != *.$extension ]]; then
    selected_path+=".$extension"
  fi

  printf '%s\n' "$selected_path"
}

finish_video() {
  local save_path
  save_path="$(choose_save_path mp4)"
  mv "$recording_file" "$save_path"
  printf 'file://%s\r\n' "$save_path" | wl-copy -t text/uri-list
  notify "Stopped Recording" "Video saved to $save_path"
}

finish_gif() {
  local save_path
  notify "Stopped Recording" "Converting recording to GIF..."

  ffmpeg -y -i "$recording_file" \
    -vf "fps=10,scale='min(1400,iw)':-2:flags=lanczos,palettegen" \
    "$palette_file"
  ffmpeg -y -i "$recording_file" -i "$palette_file" \
    -lavfi "fps=10,scale='min(1400,iw)':-2:flags=lanczos[video];[video][1:v]paletteuse" \
    "$unoptimized_gif"
  gifsicle -O3 --lossy=100 "$unoptimized_gif" -o "$optimized_gif"

  save_path="$(choose_save_path gif)"
  mv "$optimized_gif" "$save_path"
  wl-copy -t image/gif < "$save_path"
  notify "GIF conversion completed" "GIF saved to $save_path"
}

finish_recording() {
  if [[ ! -s "$recording_file" ]]; then
    notify "Recording failed" "No recording was produced"
    cleanup
    return 1
  fi

  case "$(<"$mode_file")" in
    video) finish_video ;;
    gif) finish_gif ;;
  esac

  cleanup
}

start_recording() {
  local mode="$1"
  shift

  if is_recording; then
    notify "Recording already active" "Stop the current recording before starting another"
    return 1
  fi

  mkdir -p "$output_dir" "$state_dir"
  cleanup
  printf '%s\n' "$mode" > "$mode_file"
  date +'%Y-%m-%d_%H-%M-%S' > "$name_file"
  notify "Starting Recording" "Your screen is being recorded"

  set +e
  timeout --signal=INT --kill-after=5s 600 \
    wf-recorder "$@" -f "$recording_file"
  local recorder_status=$?
  set -e

  finish_recording

  if ((recorder_status != 0 && recorder_status != 124 && recorder_status != 130)); then
    return "$recorder_status"
  fi
}

record_screen() {
  local output
  output="$(hyprctl activeworkspace -j | jq -er '.monitor')"
  start_recording video -o "$output"
}

record_area() {
  local geometry
  geometry="$(slurp)" || return 0
  [[ -n "$geometry" ]] || return 0
  start_recording "$1" -g "$geometry"
}

stop_recording() {
  if ! is_recording; then
    notify "No recording active" "There is no recording to stop"
    return 0
  fi

  pkill -INT -x wf-recorder
  notify "Stopping Recording" "Finishing the recording..."
}

launch_recording() {
  local action="${1:-}"

  case "$action" in
    screen | area | gif) ;;
    *)
      echo "Usage: record launch {screen|area|gif}" >&2
      return 2
      ;;
  esac

  systemd-run \
    --user \
    --collect \
    --quiet \
    --service-type=exec \
    --unit=screen-recorder \
    "$0" "$action"
}

case "${1:-}" in
  screen) record_screen ;;
  area) record_area video ;;
  gif) record_area gif ;;
  stop) stop_recording ;;
  launch) launch_recording "${2:-}" ;;
  *)
    echo "Usage: record {screen|area|gif|stop|launch}" >&2
    exit 2
    ;;
esac
