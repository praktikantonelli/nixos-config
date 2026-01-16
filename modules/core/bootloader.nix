{ pkgs, host, ... }: {
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = false;
    useOSProber = false;
    # Add Windows boot entry and make it appear before NixOS
    extraEntriesBeforeNixOS = true;
    extraEntries = if host == "desktop" then ''
      menuentry 'Windows Boot Manager (on /dev/nvme1n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-ABD2-3058' {
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root ABD2-3058
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '' else
      "";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
