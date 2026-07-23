#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

init() {
  # Colors
  NORMAL=$(tput sgr0)
  WHITE=$(tput setaf 7)
  BLACK=$(tput setaf 0)
  RED=$(tput setaf 1)
  GREEN=$(tput setaf 2)
  YELLOW=$(tput setaf 3)
  BLUE=$(tput setaf 4)
  MAGENTA=$(tput setaf 5)
  CYAN=$(tput setaf 6)
  BRIGHT=$(tput bold)
  UNDERLINE=$(tput smul)
}

confirm() {
  echo -en "[${GREEN}y${NORMAL}/${RED}n${NORMAL}]: "
  read -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 0
  fi
}

print_header() {
  echo -E "$CYAN 
     _                                              _                   _ _ _ 
    | |                       /\        /\         | |                 | | (_)
    | |    _   _  ___ __ _   /  \      /  \   _ __ | |_ ___  _ __   ___| | |_ 
    | |   | | | |/ __/ _  | / /\ \    / /\ \ | '_ \| __/ _ \| '_ \ / _ \ | | |
    | |___| |_| | (_| (_| |/ ____ \  / ____ \| | | | || (_) | | | |  __/ | | |
    |______\__,_|\___\__,_/_/    \_\/_/    \_\_| |_|\__\___/|_| |_|\___|_|_|_|
        _   _ _       ___        ___           _        _ _           
        | \ | (_)_  __/ _ \ ___  |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
        |  \| | \ \/ / | | / __|  | || '_ \/ __| __/ _' | | |/ _ \ '__|
        | |\  | |>  <| |_| \__ \  | || | | \__ \ || (_| | | |  __/ |   
        |_| \_|_/_/\_\\\\___/|___/ |___|_| |_|___/\__\__,_|_|_|\___|_| 


                    $BLUE https://github.com/Frost-Phoenix $RED 
        ! To make sure everything runs correctly DONT run as root ! $GREEN
                            -> '"./install.sh"' $NORMAL

    "
}

get_username() {
  echo -en "Enter your$GREEN username$NORMAL : $YELLOW"
  read -r username

  if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "Invalid username. Use lowercase letters, digits, underscores, and hyphens."
    exit 1
  fi

  echo -en "$NORMAL"
  echo -en "Use ${YELLOW}${username}${NORMAL} as ${GREEN}username${NORMAL}? "
  confirm
}

set_username() {
  if ! grep -Eq '^[[:space:]]*username = "[^"]+";' flake.nix; then
    echo "Could not find the central username declaration in flake.nix."
    exit 1
  fi

  sed -Ei 's/^([[:space:]]*username = ")[^"]+(";)/\1'"${username}"'\2/' flake.nix
}

get_host() {
  echo -en "Choose a ${GREEN}host${NORMAL} - [${YELLOW}D${NORMAL}]esktop, [${YELLOW}L${NORMAL}]aptop or [${YELLOW}H${NORMAL}]omelab: "
  read -n 1 -r
  echo

  if [[ $REPLY =~ ^[Dd]$ ]]; then
    HOST='desktop'
  elif [[ $REPLY =~ ^[Ll]$ ]]; then
    HOST='laptop'
  elif [[ $REPLY =~ ^[Hh]$ ]]; then
    HOST='homelab'
  else
    echo "Invalid choice. Please select 'D' for desktop, 'L' for laptop or 'H' for homelab"
    exit 1
  fi

  echo -en "$NORMAL"
  echo -en "Use the ${YELLOW}${HOST}${NORMAL} ${GREEN}host${NORMAL}? "
  confirm
}

install() {
  echo -e "\n${RED}START INSTALL PHASE${NORMAL}\n"
  sleep 0.2

  # do not need wallpapers etc. on headless homelab instance
  if [[ "$HOST" != "homelab" ]]; then
    # Create basic directories
    echo -e "Creating folders:"
    echo -e "    - ${MAGENTA}~/Documents${NORMAL}"
    echo -e "    - ${MAGENTA}~/Pictures/wallpapers/others${NORMAL}"
    mkdir -p "$HOME/Documents"
    mkdir -p "$HOME/Pictures/wallpapers/others"
    sleep 0.2

    # Copy the wallpapers
    echo -e "Installing ${MAGENTA}wallpapers${NORMAL}"
    if [[ ! -e "$HOME/Pictures/wallpapers/wallpaper.png" ]]; then
      install -Dm644 wallpapers/wallpaper.png "$HOME/Pictures/wallpapers/wallpaper.png"
    fi
    if [[ ! -e "$HOME/Pictures/wallpapers/others/lock-screen.png" ]]; then
      install -Dm644 wallpapers/lock-screen.png "$HOME/Pictures/wallpapers/others/lock-screen.png"
    fi
    sleep 0.2
  fi

  # Get the hardware configuration
  echo -e "Copying ${MAGENTA}/etc/nixos/hardware-configuration.nix${NORMAL} to ${MAGENTA}./hosts/${HOST}/${NORMAL}\n"
  cp /etc/nixos/hardware-configuration.nix "hosts/${HOST}/hardware-configuration.nix"
  sleep 0.2

  # Last Confirmation
  echo -en "You are about to start the system build, do you want to process ? "
  confirm

  # Start with LazyVim config setup
  # NeoVim itself will be installed by home-manager afterwards
  if [[ -e "$HOME/.config/nvim" ]]; then
    echo "Skipping NeoVim config clone because $HOME/.config/nvim already exists."
  else
    echo "Cloning NeoVim config into $HOME/.config/nvim"
    git clone git@github.com:praktikantonelli/lazyvim-config.git "$HOME/.config/nvim"
  fi

  # Build the system (flakes + home manager)
  echo -e "\nBuilding dotfiles with home-manager...\n"
  nix run ".#homeConfigurations.${username}@${HOST}.activationPackage" --extra-experimental-features "nix-command flakes" -- switch
  echo -e "\nBuilding NixOS core configuration...\n"
  nixos-rebuild switch --flake ".#${HOST}" --sudo
}

ssh_key_handling() {
  echo "Setting up ssh key..."
  # Check for existing ssh keys
  local files=("id_rsa.pub" "id_ecdsa.pub" "id_ed25519.pub")
  local file

  # Loop through each file
  for file in "${files[@]}"; do
    if [ -e "$HOME/.ssh/$file" ]; then
      echo "Found $file."
      copy_public_key "$HOME/.ssh/$file"
      return 0
    fi
  done

  # If no file is found, generate a key and add it to the agent
  echo "No key was found, would you like to generate one?"
  confirm
  echo "Please enter the email address you wish to use for the key:"
  read -r email
  echo "Use email $email?"
  confirm
  echo "Generating ssh key..."
  ssh-keygen -t ed25519 -C "$email"
  echo "Adding key to ssh-agent..."
  if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
    ssh-add "$HOME/.ssh/id_ed25519"
  else
    echo "No ssh-agent is available; SSH will read the key directly."
  fi
  copy_public_key "$HOME/.ssh/id_ed25519.pub"
}

copy_public_key() {
  local public_key="$1"

  if command -v wl-copy >/dev/null 2>&1; then
    wl-copy < "$public_key"
    echo "Copied the public key to the clipboard."
  else
    echo "wl-copy is unavailable. Add this public key to GitHub:"
    cat "$public_key"
  fi
}

verify_secrets_access() {
  local secrets_repository="git@github.com:praktikantonelli/nix-secrets.git"

  echo "Checking access to the private secrets repository..."
  if git ls-remote "$secrets_repository" HEAD >/dev/null 2>&1; then
    echo "Private secrets repository is accessible."
    return 0
  fi

  echo "Unable to access $secrets_repository"
  echo "Add or unlock the SSH key copied or shown above, then run the installer again."
  return 1
}

main() {
  cd "$REPO_ROOT"
  init

  print_header

  get_username
  set_username
  get_host

  ssh_key_handling
  verify_secrets_access || return 1

  install
}

main
