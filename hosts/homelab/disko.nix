{ inputs, ... }:

{
  modules = [
    inputs.disko.nixosModules.disko
  ];
  disko.devices = {
    disk = {
      # 128 GB Samsung SSD:
      # EFI system partition + NixOS root filesystem.
      system = {
        type = "disk";
        device = "/dev/disk/by-id/ata-SAMSUNG_MZNLF128HCHP-00000_S28TNXAGB29091";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };

            root = {
              size = "100%";

              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";

                # Reserve only 1% for root instead of ext4's
                # normal 5%, which is excessive on this disk.
                extraArgs = [
                  "-m"
                  "1"
                ];

                mountOptions = [
                  "noatime"
                ];
              };
            };
          };
        };
      };

      # 1 TB Seagate HDD:
      # Bulk application and media data mounted at /srv.
      data = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST1000DM003-1ER162_W4Y6LJSV";

        content = {
          type = "gpt";

          partitions = {
            srv = {
              size = "100%";

              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/srv";

                # A data-only filesystem does not need reserved
                # blocks for the root user.
                extraArgs = [
                  "-m"
                  "0"
                ];

                mountOptions = [
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
