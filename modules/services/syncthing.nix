{ inputs, host, lib, ... }:
let
  allDevices = {
    "Desktop-Windows" = { id = inputs.secrets.syncthing-ids.windows; };
    "phone" = { id = inputs.secrets.syncthing-ids.phone; };
    "laptop" = { id = inputs.secrets.syncthing-ids.laptop; };
    "homelab" = { id = inputs.secrets.syncthing-ids.homelab; };
  };
  peers = lib.removeAttrs allDevices
    [ host ]; # avoids referencing only other devices for folders
  peerNames = builtins.attrNames peers;
in {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "luca";
    configDir =
      "/home/luca/.config/syncthing"; # set to somewhere in home directory to have access with user

    settings = {
      devices = peers;
      folders = {
        "Library" = {
          path = "/home/luca/library";
          devices = peerNames;
        };
        "Audiobooks" = {
          path = "/home/luca/audiobooks";
          devices = peerNames;
        };
      };
    };
  };
}
