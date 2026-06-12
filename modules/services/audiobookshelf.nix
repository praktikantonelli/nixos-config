{ ... }:
{
  services.audiobookshelf = {
    enable = true;
    host = "192.168.1.212";
    port = 8084;
    user = "luca";
  };

  systemd.tmpfiles.rules = [
    "d /srv/audiobooks 2775 syncthing media - -"
  ];
}
