{ lib, ... }:
{
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableNushellIntegration = true;

    settings = {
      format = lib.concatStrings [
        "[](color_orange)"
        "$os"
        "$username"
        "[@](bg:color_orange bold fg:color_bg2)"
        "$hostname"
        "[](bg:color_yellow fg:color_orange)"
        "$directory"
        "[](fg:color_yellow bg:color_aqua)"
        "$git_branch"
        "$git_status"
        "[](fg:color_aqua bg:color_blue)"
        "$nix_shell"
        "[](fg:color_blue bg:color_bg3)"
        "$cmd_duration"
        "[](fg:color_bg3) "
      ];

      palette = "gruvbox_dark";
      palettes.gruvbox_dark = {
        color_fg0 = "#FBF1C7";
        color_fg1 = "#EBDBB2";
        color_fg2 = "#D5C5A1";
        color_fg3 = "#BDAE93";
        color_fg4 = "#A89984";
        color_bg0 = "#282828";
        color_bg1 = "#3C3836";
        color_bg2 = "#504945";
        color_bg3 = "#665C54";
        color_bg4 = "#7C6F64";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#FE8019";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#D79921";
      };

      os = {
        disabled = false;
        style = "bg:color_orange bold fg:color_fg0";
        symbols = {
          NixOS = " ";
        };
      };

      username = {
        disabled = false;
        show_always = true;
        style_user = "bg:color_orange bold fg:color_bg2";
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "bg:color_orange bold fg:color_bg2";
        format = "[$hostname ]($style)";
      };

      directory = {
        style = "bold fg:color_fg1 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 3;
      };

      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](bold fg:color_fg0 bg:color_aqua)]($style)";
      };

      git_status = {
        style = "bg:color_aqua bold fg:color_fg0";
        format = "[$all_status$ahead_behind]($style)";
      };

      nix_shell = {
        format = "[ via nix $name ]($style)";
        style = "bg:color_blue bold fg:color_fg0";
      };

      time = {
        disabled = true;
      };

      cmd_duration = {
        disabled = true;
      };

      line_break = {
        disabled = false;
      };

      character = {
        disabled = false;
        success_symbol = "[  ](bold fg:color_green)";
        error_symbol = "[  ](bold fg:color_red)";
      };
    };
  };
}
