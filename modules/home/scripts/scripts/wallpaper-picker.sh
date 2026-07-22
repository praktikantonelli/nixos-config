wallpaper_path="$HOME/Pictures/wallpapers"
wallpapers_folder="$wallpaper_path/others"
current_wallpaper="$wallpaper_path/wallpaper.png"

wallpaper_name="$(
  find "$wallpapers_folder" -maxdepth 1 -type f -printf '%f\n' |
    sort |
    fuzzel --dmenu
)" || exit 0

[[ -n "$wallpaper_name" ]] || exit 0
selected_wallpaper="$wallpapers_folder/$wallpaper_name"

if [[ ! -f "$selected_wallpaper" ]]; then
  echo "Wallpaper not found: $selected_wallpaper" >&2
  exit 1
fi

cp -- "$selected_wallpaper" "$current_wallpaper"
wall-change "$current_wallpaper"
