{ inputs, pkgs, ... }: {
  home.packages = (with pkgs; [
    evince # gnome pdf viewer
    eza # ls replacement
    entr # perform action when file change
    fd # find replacement
    file # Show file information
    fzf # fuzzy finder
    gifsicle # gif utility
    gtrash # rm replacement, put deleted files in system trash
    jdk8 # legacy java version for Minecraft
    libreoffice
    nemo-with-extensions # file manager
    nitch # systhem fetch util
    nix-prefetch-github
    prismlauncher # minecraft launcher
    ripgrep # grep replacement
    tdf # cli pdf viewer
    yazi # terminal file manager
    zenity

    obsidian
    dust
    lshw

    bleachbit # cache cleaner
    gparted # partition manager
    imv # image viewer
    killall
    libnotify
    man-pages # extra man pages
    mpv # video player
    ncdu # disk space
    openssl
    pamixer # pulseaudio command line mixer
    pavucontrol # pulseaudio volume controle (GUI)
    playerctl # controller for media players
    wl-clipboard # clipboard utils for wayland (wl-copy, wl-paste)
    cliphist # clipboard manager
    poweralertd
    qalculate-gtk # calculator
    unzip
    wget
    xdg-utils
    # sops
    age
    ssh-to-age
  ]);
}
