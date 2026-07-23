if hyprctl getoption decoration:blur:enabled | grep -q "int: 1"; then
  hyprctl keyword decoration:blur:enabled false >/dev/null
else
  hyprctl keyword decoration:blur:enabled true >/dev/null
fi
