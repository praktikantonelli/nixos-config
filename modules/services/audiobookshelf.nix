{ ... }: {
  services.audiobookshelf = {
    enable = true;
    host = "192.168.1.212";
    port = 8084;
    user = "luca";
  };
}
