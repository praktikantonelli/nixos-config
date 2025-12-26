{ ... }:
let
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "15px";
    font_weight = "bold";
    text_color = "#ebdbb2";
    secondary_accent = "#d79921";
    tertiary_accent = "#fe8019";
    background = "#11111B";
    opacity = "0.98";
  };
in {
  programs.waybar.style = ''

    * {
        border: none;
        border-radius: 0px;
        padding: 0;
        margin: 0;
        min-height: 0px;
        font-family: ${custom.font};
        font-weight: ${custom.font_weight};
        opacity: ${custom.opacity};
    }

    window#waybar {
        background: none;
    }

    #workspaces {
        font-size: 18px;
        padding-left: 15px;
        
    }
    #workspaces button {
        color: ${custom.text_color};
        padding-left:  6px;
        padding-right: 6px;
    }
    #workspaces button.empty {
        color: #a89984;
    }
    #workspaces button.active {
        color: #ebdbb2;
    }

    #tray, #pulseaudio, #network, #cpu, #memory, #disk, #clock, #battery, #custom-notification, #bluetooth {
        font-size: ${custom.font_size};
        color: ${custom.text_color};
    }

    #cpu {
        padding-left: 7px;
        padding-right: 9px;
        margin-left: 7px;
    }

    #memory {
        padding-left: 9px;
        padding-right: 9px;
    }
    #disk {
        padding-left: 9px;
        padding-right: 15px;
    }

    #tray {
        padding-left: 35px;
        padding-right: 15px;
    }

    #bluetooth {
        padding-left: 7px;
        padding-right: 7px;
    }

    #tray menu {
        font-size: ${custom.font_size};
        color: ${custom.text_color};
    }

    #tray.passive, #tray>.passive, #tray>passive, #tray> .passive, #tray passive {
        font-size: ${custom.font_size};
        color: ${custom.text_color};
    }

    #tray.active, #tray>.active, #tray>active, #tray> .active, #tray active {
        font-size: ${custom.font_size};
        color: ${custom.text_color};
    }

    #pulseaudio {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
    }
    #battery {
        padding-left: 9px;
        padding-right: 9px;
    }
    #network {
        padding-left: 9px;
        padding-right: 30px;
    }

    custom-notification {
        padding-left: 20px;
        padding-right: 20px;
    }

    #clock {
        padding-left: 9px;
        padding-right: 15px;
    }

    #custom-launcher {
        font-size: 20px;
        color: #ebdbb2;
        font-weight: ${custom.font_weight};
        padding-left: 10px;
        padding-right: 15px;
    }
  '';
}
