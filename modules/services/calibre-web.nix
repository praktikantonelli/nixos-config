{ pkgs, ... }:
let
  calibre-web-with-kobo = pkgs.calibre-web.overridePythonAttrs (oldAttrs: {
    dependencies = (oldAttrs.dependencies or [ ]) ++ pkgs.calibre-web.optional-dependencies.kobo;

    # The current Calibre-Web snapshot has upper bounds that are too
    # restrictive for the certifi and chardet versions in this Nixpkgs pin.
    pythonRelaxDeps = pkgs.lib.unique (
      (oldAttrs.pythonRelaxDeps or [ ])
      ++ [
        "certifi"
        "chardet"
      ]
    );
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
      ip = "127.0.0.1";
      port = 8083;
    };
  };
}
