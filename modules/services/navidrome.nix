{ ... }: {
  services.navidrome = {
    enable = true;
    group = "media";
    settings = {
      Address = "127.0.0.1";
      MusicFolder = "/srv/music";
      Scanner.Schedule = "@every 1h";
    };
  };
}
