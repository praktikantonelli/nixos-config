#!/usr/bin/env bash

init() {
  # Vars
  CURRENT_USERNAME='luca'

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
  read username
  echo -en "$NORMAL"
  echo -en "Use$YELLOW "$username"$NORMAL as ${GREEN}username${NORMAL} ? "
  confirm
}

set_username() {
  sed -i -e "s/${CURRENT_USERNAME}/${username}/g" ./flake.nix
  sed -i -e "s/${CURRENT_USERNAME}/${username}/g" ./modules/home/audacious/config
}

get_host() {
  echo -en "Choose a ${GREEN}host${NORMAL} - [${YELLOW}D${NORMAL}]esktop or [${YELLOW}L${NORMAL}]aptop: "
  read -n 1 -r
  echo

  if [[ $REPLY =~ ^[Dd]$ ]]; then
    HOST='desktop'
  elif [[ $REPLY =~ ^[Ll]$ ]]; then
    HOST='laptop'
  else
    echo "Invalid choice. Please select 'D' for desktop or 'L' for laptop"
    exit 1
  fi

  echo -en "$NORMAL"
  echo -en "Use the$YELLOW "$HOST"$NORMAL ${GREEN}host${NORMAL} ? "
  confirm
}

install() {
  echo -e "\n${RED}START INSTALL PHASE${NORMAL}\n"
  sleep 0.2

  # Create basic directories
  echo -e "Creating folders:"
  echo -e "    - ${MAGENTA}~/Documents${NORMAL}"
  echo -e "    - ${MAGENTA}~/Pictures/wallpapers/others${NORMAL}"
  mkdir -p ~/Documents
  mkdir -p ~/Pictures/wallpapers/others
  sleep 0.2

  # Copy the wallpapers
  echo -e "Copying all ${MAGENTA}wallpapers${NORMAL}"
  cp -r wallpapers/wallpaper.png ~/Pictures/wallpapers
  cp -r wallpapers/lock-screen.png ~/Pictures/wallpapers/others
  sleep 0.2

  # Get the hardware configuration
  echo -e "Copying ${MAGENTA}/etc/nixos/hardware-configuration.nix${NORMAL} to ${MAGENTA}./hosts/${HOST}/${NORMAL}\n"
  cp /etc/nixos/hardware-configuration.nix hosts/${HOST}/hardware-configuration.nix
  sleep 0.2

  # General installation will be via HTTPS, not ssh -> switch
  git remote set-url origin git@github.com:praktikantonelli/nixos-config.git

  # Last Confirmation
  echo -en "You are about to start the system build, do you want to process ? "
  confirm

  # Start with LazyVim config setup
  # NeoVim itself will be installed by home-manager afterwards
  echo -en "Cloning NeoVim config into ~/.config/nvim"
  git clone git@github.com:praktikantonelli/lazyvim-config.git ~/.config/nvim

  # Build the system (flakes + home manager)
  echo -e "\nBuilding dotfiles with home-manager...\n"
  nix run .#homeConfigurations."${username}@${HOST}".activationPackage --extra-experimental-features "nix-command flakes" -- switch
  echo -e "\nBuilding NixOS core configuration...\n"
  sudo nixos-rebuild switch --flake .#${HOST}
}

ssh_key_handling() {
  echo "Setting up ssh key..."
  # Check for existing ssh keys
  files=("id_rsa.pub" "id_ecdsa.pub" "id_ed25519.pub")

  # Loop through each file
  for file in "${files[@]}"; do
    if [ -e "$HOME/.ssh/$file" ]; then
      # Perform some operation when a file is found
      echo "Found $file, copying public key to clipboard..."

      # Example operation: print the contents of the found file
      cat "$HOME/.ssh/$file" | wl-copy

      # Exit the function after the first match
      exit 0
    fi
  done

  # If no file is found, generate a key and add it to the agent
  echo "No key was found, would you like to generate one?"
  confirm
  echo "Please enter the email address you wish to use for the key:"
  read email
  echo "Use email $email?"
  confirm
  echo "Generating ssh key..."
  ssh-keygen -t ed25519 -C "$email"
  echo "Adding key to ssh-agent..."
  ssh-add ~/.ssh/id_ed25519
  echo "Copying key to clipboard..."
  cat ~/.ssh/id_ed25519.pub | wl-copy
}

main() {
  init

  print_header

  get_username
  set_username
  get_host

  install

  ssh_key_handling
}

main && exit 0
