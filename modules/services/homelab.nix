{ ... }:
{
  imports = [
    ./nginx.nix
    ./immich.nix
    ./fail2ban.nix
    ./nextcloud.nix
    ./onlyoffice.nix
    ./vaultwarden.nix
    ./cloudflared.nix
    ./audiobookshelf.nix
    ./syncthing.nix
    ./navidrome.nix
    ./bookorbit.nix
    ./paperless.nix
    ./zennotes.nix
    ./comin.nix
  ];
}
