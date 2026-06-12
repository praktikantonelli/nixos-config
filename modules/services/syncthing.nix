{
  inputs,
  host,
  lib,
  ...
}:
let
  allDevices = {
    "Desktop-Windows" = {
      id = inputs.secrets.syncthing-ids.windows;
    };
    "phone" = {
      id = inputs.secrets.syncthing-ids.phone;
    };
    "laptop" = {
      id = inputs.secrets.syncthing-ids.laptop;
    };
    "homelab" = {
      id = inputs.secrets.syncthing-ids.homelab;
    };
  };
  peers = lib.removeAttrs allDevices [ host ]; # avoids referencing only other devices for folders
  peerNames = builtins.attrNames peers;
in
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "syncthing";
    group = "syncthing";

    settings = {
      devices = peers;
      folders = {
        "Library" = {
          path = "/srv/library";
          devices = peerNames;
          ignorePerms = true;
        };
        "Audiobooks" = {
          path = "/srv/audiobooks";
          devices = peerNames;
          ignorePerms = true;
        };
        "Music" = {
          path = "/srv/music";
          devices = peerNames;
          ignorePerms = true;
        };
      };
    };
  };

  # add syncthing user to media group for accessing media directories in /srv
  users.users.syncthing.extraGroups = [ "media" ];

  # make syncthing-created files group-readable/writable
  systemd.services.syncthing.serviceConfig = {
    UMask = "0002";
    SupplementaryGroups = [ "media" ];
  };
}
