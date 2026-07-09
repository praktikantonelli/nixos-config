{ username, ... }: {
  services.hyprlogin = {
    enable = true;

    kbLayout = "ch";
    extraHyprloginConfig = ''
      sessions {
        default_user = ${username}
        default_session = hyprland.desktop
      }

      general {
        # useful while testing; disable after it works
        debug_mode = true
      }
    '';

    extraHyprlandConfig = ''
      monitor = ,preferred,auto,1

      input {
        kb_layout = ch
      }
    '';
  };
}
