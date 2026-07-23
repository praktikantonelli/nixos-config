unicode=" "

_black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
_white=$(tput setaf 7)
bold=$(tput bold)
normal=$(tput sgr0)

up="$(uptime | awk -F'( |,|:)+' '{
        h=m=0;
        if ($7=="min")
            m=$6;
        else {
            if ($7~/^day/) { h=$8; m=$9 }
            else {h=$6;m=$7}
        }
    }
    { printf "%dh %dm", h+0, m+0 }
')"

package_count="$(nix-store --query --requisites /run/current-system | wc -l)"
desktop="${XDG_CURRENT_DESKTOP:-unknown}"
shell_name="${SHELL:-unknown}"
shell_name="${shell_name##*/}"

fetch() {
  printf '%s%s%s%s\n' "$cyan" "$bold" '     _  ___      ____  ____    ' "$normal"
  printf '%s%s%s%s\n' "$cyan" "$bold" '    / |/ (_)_ __/ __ \/ __/    ' "$normal"
  printf '%s%s%s%s\n' "$cyan" "$bold" '   /    / /\ \ / /_/ /\ \      ' "$normal"
  printf '%s%s%s%s\n' "$cyan" "$bold" '  /_/|_/_//_\_\\____/___/  ' "$normal"
  echo ""
  echo "  ╭─────────────╮ "
  echo "  │  ${red} ${normal} user    │ ${red}$(whoami)${normal}"
  echo "  │  ${yellow} ${normal} distro  │ ${yellow}$(sed -nE "s@PRETTY_NAME=\"([^\"]*)\"@\1@p" /etc/os-release)${normal} "
  echo "  │  ${green} ${normal} kernel  │ ${green}$(uname -r)${normal} "
  echo "  │  ${cyan}󱂬 ${normal} de/wm   │ ${cyan}${desktop}${normal} "
  echo "  │  ${blue} ${normal} uptime  │ ${blue}${up}${normal} "
  echo "  │  ${magenta} ${normal} shell   │ ${magenta}${shell_name}${normal} "
  echo "  │  ${red}󰏖 ${normal} pkgs    │ ${red}${package_count}${normal} "
  echo "  ├─────────────┤ "
  echo "  │  ${_white}  ${normal}colors  │${_white}$unicode${normal}${red}$unicode${normal}${yellow}$unicode${normal}${green}$unicode${normal}${cyan}$unicode${normal}${blue}$unicode${normal}${magenta}$unicode${normal}${_black}$unicode${normal}"
  echo "  ╰─────────────╯ "
}

fetch
