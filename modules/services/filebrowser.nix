{ pkgs, ... }: {
  services.filebrowser = {
    enable = true;
    package = pkgs.filebrowser-quantum;
    openFirewall = true;
    settings = {
      port = 9090;
      address = "192.168.1.212";
    };
  };
}
