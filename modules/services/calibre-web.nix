{ pkgs, lib, ... }:
let
  calibre-web-with-kobo = pkgs.calibre-web.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies
      ++ [ pkgs.calibre-web.optional-dependencies.kobo ];
  });
in {
  services.calibre-web = {
    enable = true;
    package = calibre-web-with-kobo;
    options = {
      enableBookUploading = true;
      enableKepubify = true;
      calibreLibrary = "/srv/library";
    };
    group = "media"; # allow using syncthing to sync library
    listen = {
      ip = "192.168.1.212";
      port = 8083;
    };
  };
}
