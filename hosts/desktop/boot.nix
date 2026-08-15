{ ... }: {
  boot.loader.grub = {
    # set to true on new install, detects Windows boot entry
    useOSProber = false;
    # Add Windows boot entry and make it appear before NixOS
    extraEntriesBeforeNixOS = false;
    extraEntries = ''
      menuentry 'Windows Boot Manager (on /dev/nvme1n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-ABD2-3058' {
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root ABD2-3058
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };
}
