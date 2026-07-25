{ ... }: {
  services.immich = {
    enable = true;
    port = 2283;
    host = "192.168.1.243";
    mediaLocation = "/srv/immich";
  };

  # immich does not create this directory automatically
  systemd.tmpfiles.rules = [
    # create the directory and grant the immich user read, write and execute permissions
    "d /srv/immich 0700 immich immich -"
  ];

}
