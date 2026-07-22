{ ... }:
{
  services.audiobookshelf = {
    enable = true;
    host = "127.0.0.1";
    port = 8084;
    group = "media";
  };
}
