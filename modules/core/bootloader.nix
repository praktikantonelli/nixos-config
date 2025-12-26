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
            menuentry 'Windows Boot Manager (on /dev/sdb2)' --class windows --class os $menuentry_id_option 'osprober-efi-10A6-35AF' {
      	      insmod part_gpt
      	      insmod fat
      	      set root='hd1,gpt2'
      	      if [ x$feature_platform_search_hint = xy ]; then
      	        search --no-floppy --fs-uuid --set=root --hint-bios=hd1,gpt2 --hint-efi=hd1,gpt2 --hint-baremetal=ahci1,gpt2  10A6-35AF
      	      else
      	        search --no-floppy --fs-uuid --set=root 10A6-35AF
      	      fi
      	      chainloader /efi/Microsoft/Boot/bootmgfw.efi
            }
    '' else
      "";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
