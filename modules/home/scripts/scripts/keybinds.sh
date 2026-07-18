#!/usr/bin/env bash

# TODO: adapt regex so it works with new lua config syntax
config_file=~/.config/hypr/hyprland.conf
keybinds=$(grep -oP '(?<=bind=).*' $config_file)
keybinds=$(echo "$keybinds" | sed 's/,\([^,]*\)$/ = \1/' | sed 's/, exec//g' | sed 's/^,//g')
fuzzel --width 75 --dmenu <<<"$keybinds"
