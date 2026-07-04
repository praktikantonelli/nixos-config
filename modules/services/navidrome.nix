{ ... }: {
  services.navidrome = {
    enable = true;
    group = "media";
    settings = {
      MusicFolder = "/srv/music";
      Scanner.Schedule = "@every 1h";
    };
  };
}
