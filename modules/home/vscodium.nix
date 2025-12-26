{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # nix language
        bbenoist.nix
        # nix-shell suport 
        arrterian.nix-env-selector
        # python
        # ms-python.python

        # Rust
        rust-lang.rust-analyzer
        fill-labs.dependi
        tamasfe.even-better-toml

        usernamehw.errorlens
        vscodevim.vim
        tomoki1207.pdf

        # Color theme
        pkief.material-icon-theme
        jdinhlife.gruvbox
      ];
      userSettings = {
        "update.mode" = "none";
        "extensions.autoUpdate" =
          false; # This stuff fixes vscode freaking out when theres an update
        "window.titleBarStyle" =
          "custom"; # needed otherwise vscode crashes, see https://github.com/NixOS/nixpkgs/issues/246509

        "window.menuBarVisibility" = "toggle";
        "editor.fontFamily" =
          "'JetBrainsMono Nerd Font', 'SymbolsNerdFont', 'monospace', monospace";
        "terminal.integrated.fontFamily" =
          "'JetBrainsMono Nerd Font', 'SymbolsNerdFont'";
        "editor.fontSize" = 16;
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "workbench.iconTheme" = "material-icon-theme";
        "vsicons.dontShowNewVersionMessage" = true;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmDelete" = false;
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = true;
        "workbench.startupEditor" = "none";

        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.formatOnPaste" = true;

        "workbench.layoutControl.type" = "menu";
        "workbench.editor.limit.enabled" = true;
        "workbench.editor.limit.value" = 10;
        "workbench.editor.limit.perEditorGroup" = true;
        "workbench.editor.showTabs" = "multiple";
        "files.autoSave" = "onWindowChange";
        "explorer.openEditors.visible" = 0;
        "breadcrumbs.enabled" = false;
        "editor.renderControlCharacters" = false;
        "workbench.activityBar.location" = "default";
        "workbench.statusBar.visible" = true;
        "editor.scrollbar.verticalScrollbarSize" = 2;
        "editor.scrollbar.horizontalScrollbarSize" = 2;
        "editor.scrollbar.vertical" = "hidden";
        "editor.scrollbar.horizontal" = "hidden";
        "workbench.layoutControl.enabled" = false;

        "security.workspace.trust.untrustedFiles" =
          "open"; # Always trust new files/folders

        "editor.mouseWheelZoom" = true;

        "git.enableSmartCommit" =
          true; # Automatically stage all changes when committing
        "git.confirmSync" =
          false; # Don't ask for confirmation upon pushing changes

      };
      # Keybindings
      keybindings = [
        {
          key = "ctrl+q";
          command = "editor.action.commentLine";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+s";
          command = "workbench.action.files.saveFiles";
        }
      ];
    };
  };
}
