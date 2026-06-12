{ ... }:
{
  services.navidrome = {
    enable = true;
    group = "media";
    settings = {
      MusicFolder = "/srv/music";
      Scanner.Schedule = "@every 1h";
    };
  };

  systemd.tmpfiles.rules = [
    # syncthing writes, navidrome reads only
    # 2775 = rwxrwsr-x, with setgid so new subdirs inherit group media
    "d /srv/music 2775 syncthing media - -"
  ];
}
