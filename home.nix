{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.obsidian
    pkgs.spotify
    pkgs.rectangle
    pkgs.vscode
    pkgs.rustup
    pkgs.brave
    pkgs.deno
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.shellAliases = {
    rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  # home.sessionVariables = {
  #   # EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    
    # When using the arrow keys to navigate through command history, filter the results using the currently typed command
    historySubstringSearch.enable = true;

    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        # Enables double pressing of ESC-key to recall previous command from history and adding "sudo" in front of it
        "sudo"
      ];
    };
  };

  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.rust-lang.rust-analyzer
      pkgs.vscode-extensions.svelte.svelte-vscode
      pkgs.vscode-extensions.tyriar.sort-lines
      pkgs.vscode-extensions.vscode-icons-team.vscode-icons
      pkgs.vscode-extensions.zhuangtongfa.material-theme
    ];

    userSettings = {
      "explorer.confirmDelete" = false;

      # When no files are staged, automatically stage all changed files
      "git.enableSmartCommit" = true;
      
      "git.confirmSync" = false;
      "git.autofetch" = true;

      "workbench.sideBar.location" = "right";
      "workbench.colorTheme" = "One Dark Pro Darker";
      "workbench.iconTheme" = "vscode-icons";

      # Disable "temporarily" open files
      "workbench.editor.enablePreview" = false;
      
      # Limit number of open tabs to 5
      "workbench.editor.limit.value" = 5;
      
      # Don't show search input in title bar
      "window.commandCenter" = false;

      # Use font with ligatures (installed via the nerdfonts package)
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "FiraCode Nerd Font";
    };

    keybindings = [
      # cmd+t/cmd+w shortcut for opening/closing a terminal
      {
        "key" = "cmd+t";
        "command" = "workbench.action.terminal.split";
        "when" = "terminalFocus";
      }
      {
        "key" = "cmd+w";
        "command" = "workbench.action.terminal.killActiveTab";
        "when" = "terminalFocus";
      }

      # cmd+2 shortcut for changing the focus to the terminal
      {
        "key" = "cmd+2";
        "command" = "-workbench.action.focusSecondEditorGroup";
      }
      {
        "key" = "cmd+2";
        "command" = "workbench.action.terminal.focus";
      }
      {
        "key" = "cmd+down";
        "command" = "-workbench.action.terminal.focus";
      }
    ];
  };

}