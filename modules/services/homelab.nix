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
    ./syncthing.nix
    ./navidrome.nix
    ./bookorbit.nix
    ./paperless.nix
    ./comin.nix
    ./livesync.nix
    ./mealie.nix
  ];
}
