{ ... }: {
  imports = [
    ./nginx.nix
    ./immich.nix
    ./fail2ban.nix
    ./nextcloud.nix
    ./onlyoffice.nix
    ./vaultwarden.nix
    ./cloudflared.nix
    ./minecraft.nix
    ./calibre-web.nix
    ./audiobookshelf.nix
    ./syncthing.nix
  ];
}
