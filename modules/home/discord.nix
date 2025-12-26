{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      # discord
      (discord.override { withVencord = true; })
    ];
  xdg.configFile."Vencord/themes/custom.css".text = ''
        /**
        * @name Gruvbox-dark
        * @author Ethan McTague
        * @authorId 505490445468696576
        * @version 1.0.0
        * @description 🎮 gruvbox-dark theme for Discord
        * @website https://gist.github.com/emctague/aab1d43a90174930939ae51c8db09553
        **/

        //META{"name":"Gruvbox Hard Dark","description":"Themes your Discord using Gruvbox colors.","author":"Ethan McTague","version":"1.0"}


    :root {
        --interactive-normal: #ebdbb2;
        --text-normal: #ebdbb2;
        --background-primary: #1d2021;
        --background-secondary: #181B1B;
        --background-tertiary: #1d2021;
        --channels-default: #83a598;
        --deprecated-panel-background: #161818;
        --channeltextarea-background: #32302f;
    }

    .da-popouts .da-container, .da-friendsTableHeader, .da-friendsTable, .da-autocomplete, .da-themedPopout, .da-header, .da-footer, .da-userPopout > *, .da-systemPad, .da-autocompleteHeaderBackground {
      background-color: var(--background-secondary) !important;
      border-color: transparent !important;
    }

    .theme-dark .da-messageGroupWrapper {
      background-color: var(--background-tertiary) !important;
      border-color: transparent;
    }

    .theme-dark .da-option:after {
      background-image: none !important;
    }

    .theme-dark #bd-settings-sidebar .ui-tab-bar-item {
        color: var(--interactive-normal);
    }

    .theme-dark #bd-settings-sidebar .ui-tab-bar-header, div[style*="color: rgb(114, 137, 218);"], .da-addButtonIcon  {
        color: var(--channels-default) !important;
    }

    .theme-dark #bd-settings-sidebar .ui-tab-bar-item.selected, .theme-dark .da-autocompleteRow .da-selectorSelected {
        background-color: var(--background-modifier-selected);
        color: var(--interactive-active);
    }

    .da-emojiButtonNormal .da-contents .da-sprite {
        filter: sepia(1) !important;
    }


    .da-messagesWrapper .da-scroller::-webkit-scrollbar,
    .da-messagesWrapper .da-scroller::-webkit-scrollbar-track-piece {
        background-color: var(--background-tertiary) !important;
        border-color: rgba(0,0,0,0) !important;
    }

    .da-scrollerThemed .da-scroller::-webkit-scrollbar-thumb,
    .da-scrollerWrap .da-scroller::-webkit-scrollbar-thumb {
        background-color: var(--background-secondary) !important;
        border-color: var(--background-tertiary) !important;
    }







    .hljs-deletion,
    .hljs-formula,
    .hljs-keyword,
    .hljs-link,
    .hljs-selector-tag {
      color: #fb4934;
    }

    .hljs-built_in,
    .hljs-emphasis,
    .hljs-name,
    .hljs-quote,
    .hljs-strong,
    .hljs-title,
    .hljs-variable {
      color: #83a598;
    }

    .hljs-attr,
    .hljs-params,
    .hljs-template-tag,
    .hljs-type {
      color: #fabd2f;
    }

    .hljs-builtin-name,
    .hljs-doctag,
    .hljs-literal,
    .hljs-number {
      color: #8f3f71;
    }

    .hljs-code,
    .hljs-meta,
    .hljs-regexp,
    .hljs-selector-id,
    .hljs-template-variable {
      color: #fe8019;
    }

    .hljs-addition,
    .hljs-meta-string,
    .hljs-section,
    .hljs-selector-attr,
    .hljs-selector-class,
    .hljs-string,
    .hljs-symbol {
      color: #b8bb26;
    }

    .hljs-attribute,
    .hljs-bullet,
    .hljs-class,
    .hljs-function,
    .hljs-function .hljs-keyword,
    .hljs-meta-keyword,
    .hljs-selector-pseudo,
    .hljs-tag {
      color: #8ec07c;
    }

    .hljs-comment {
      color: #928374;
    }

    .hljs-link_label,
    .hljs-literal,
    .hljs-number {
      color: #d3869b;
    }

    .hljs-comment,
    .hljs-emphasis {
      font-style: italic;
    }

    .hljs-section,
    .hljs-strong,
    .hljs-tag {
      font-weight: bold;
    }

  '';
}
