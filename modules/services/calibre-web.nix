{ pkgs, ... }:
let
  calibre-web-with-kobo = pkgs.calibre-web.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies
      ++ [ pkgs.calibre-web.optional-dependencies.kobo ];
  });
in
{

  # calibre-web currently pulls in a broken version of pip-chill (1.0.3) -> override with 1.0.5 until fixed upstream
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (_pythonFinal: pythonPrev: {
          pip-chill = pythonPrev.pip-chill.overridePythonAttrs (_oldAttrs: rec {
            version = "1.0.5";

            src = final.fetchPypi {
              pname = "pip_chill";
              inherit version;
              hash = "sha256-55vFFKv+FE8u9SKQ9ZZ30nnLBbQIT6n4FLvlzA6gTBw=";
            };

            dependencies = [ ];
          });
        })
      ];
    })
  ];

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
