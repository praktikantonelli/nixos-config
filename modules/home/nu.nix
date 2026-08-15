{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  zellijBin = lib.getExe pkgs.zellij;
in
{
  programs = {
    nushell = {
      enable = true;
      environmentVariables = {
        EDITOR = "nvim";
      };
      settings = {
        show_banner = false;
      };
      extraConfig = ''
        $env.config = {
          hooks: {
            pre_prompt: [
              { ||
                if (which direnv | is-empty) {
                  return
                }

                direnv export json | from json | default {} | load-env

                if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
                  $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
                }
              }

              ${lib.optionalString config.programs.zellij.enable ''
                { ||  # zellij auto-attach
                  let in_zellij = ('ZELLIJ' in $env)
                  let term = ($env | get --optional TERM | default "")

                  if $nu.is-interactive and (not $in_zellij) and ($term != "dumb") {
                    exec ${zellijBin} attach --create ($env | get --optional USER | default 'user')
                  }
                }   
              ''}
            ]
          }
        }

        def gcma [msg:string] {
          git add .
          git commit -m $msg
        }

        def gcm [msg:string] {
          git commit -m $msg
        }
      '';

      # also define NH_FLAKE here so nushell has access to it -> needed for nix-helper on homelab
      extraEnv = ''$env.NH_FLAKE = "/home/${username}/nixos-config"'';
      shellAliases = {

        # Utils
        c = "clear";
        cd = "z";
        cat = "bat";
        code = "codium";
        open = "xdg-open";
        clip = "wl-copy < "; # use with file path to copy file content
        tree = "eza --icons --tree --group-directories-first";

        # Nixos
        nix-switch = "nh os switch";
        nix-flake-update = "nh os  switch --update"; # Upgrade just the flake inputs
        nix-list = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        nix-clean = "nh clean all --keep 5 --no-gcroots";
        hm-switch = "nh home switch";
        hm-list = "home-manager generations";
        nix-switch-all = "hm-switch and nix-switch";

        # Git
        ga = "git add";
        gaa = "git add --all";
        gs = "git status";
        gb = "git branch";
        gm = "git merge";
        gpl = "git pull";
        gplo = "git pull origin";
        gps = "git push";
        gpst = "git push --follow-tags";
        gpso = "git push origin";
        gc = "git commit";
        gtag = "git tag -ma";
        gch = "git checkout";
        gchb = "git checkout -b";

      };

    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
