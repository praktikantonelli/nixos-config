{ inputs, pkgs, ... }: {
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    profiles.luca = {
      id = 0;
      name = "luca";
      isDefault = true;
      extensions.packages =
        with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          duckduckgo-privacy-essentials
          reddit-enhancement-suite
          bitwarden
          vimium
          gruvbox-dark-theme
        ];
      settings = {
        # Enable regular firefox themes 
        "zen.theme.disable-lightweight" = false;
        # Enable userChrome.css content, needed to tweak gruvbox theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        /* =========================================================
           Zen + lightweight theme contrast fix (Gruvbox Dark “bright”)
           Forces readable text/icons on dark toolbars + bookmarks bar
           ========================================================= */

        :root {
          /* Gruvbox Dark (bright-leaning) */
          --gb-fg:        #fbf1c7; /* bright foreground */
          --gb-fg-muted:  #ebdbb2;
          --gb-yellow:    #fabd2f;
          --gb-orange:    #fe8019;
          --gb-green:     #b8bb26;
          --gb-aqua:      #8ec07c;
          --gb-blue:      #83a598;
          --gb-purple:    #d3869b;
          --gb-red:       #fb4934;

          /* Pick your main UI foreground here */
          --zen-fg:       var(--gb-fg);
          --zen-fg-2:     var(--gb-fg-muted);
          --zen-accent:   var(--gb-yellow);
        }

        /* --- Main toolbars should inherit a readable foreground --- */
        #navigator-toolbox,
        #toolbar-menubar,
        #nav-bar,
        #PersonalToolbar {
          color: var(--zen-fg) !important;
        }

        /* --- Buttons / icons / labels in toolbars --- */
        toolbarbutton,
        toolbarbutton *,
        .toolbarbutton-icon,
        .toolbarbutton-text,
        #nav-bar toolbarbutton *,
        #PersonalToolbar toolbarbutton * {
          color: var(--zen-fg) !important;
          fill:  var(--zen-fg) !important; /* SVG icons */
        }

        /* --- URL bar + its icons (shield, star, etc.) --- */
        #urlbar,
        #urlbar * {
          color: var(--zen-fg) !important;
          fill:  var(--zen-fg) !important;
        }

        /* --- Bookmarks toolbar text --- */
        #PersonalToolbar .bookmark-item,
        #PersonalToolbar .bookmark-item * {
          color: var(--zen-fg) !important;
          fill:  var(--zen-fg) !important;
        }

        /* --- Menus / overflow panels often inherit poorly; enforce fg --- */
        panel,
        panelview,
        menupopup,
        menu,
        menuitem,
        .subviewbutton,
        .panel-subview-body,
        .PanelUI-subView {
          color: var(--zen-fg) !important;
        }

        /* --- Hover / active states: use a bright Gruvbox accent --- */
        toolbarbutton:hover,
        toolbarbutton:hover *,
        #PersonalToolbar .bookmark-item:hover,
        #PersonalToolbar .bookmark-item:hover * {
          color: var(--zen-accent) !important;
          fill:  var(--zen-accent) !important;
        }

        /* --- Optional: muted/secondary labels (uncomment if you want) --- */
        /*
        #identity-box,
        #tracking-protection-icon-container,
        #notification-popup-box {
          color: var(--zen-fg-2) !important;
          fill:  var(--zen-fg-2) !important;
        }
        */
      '';

    };
  };
}
