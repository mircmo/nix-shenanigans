{ pkgs, self, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
          pkgs.vim
          pkgs.obsidian
          pkgs.spotify
          pkgs.rectangle
          pkgs.vscode
          pkgs.rustup
          pkgs.brave
      ];

      nixpkgs.config.allowUnfree = true;

      system.defaults = {
          dock = {
            autohide = true;
            tilesize = 42;
            magnification = true;
            largesize = 48;
            show-recents = false;

            # Somehow this breaks darwin rebuild ??!?
            # persistent-apps = [
            #   # "/System/Applications/Utilities/Terminal.app"
            #   pkgs.obsidian
            #   pkgs.spotify
            #   pkgs.vscode
            # ];
          };
          finder = {
            AppleShowAllFiles = true;
            AppleShowAllExtensions = true;
            ShowPathbar = true;
            _FXShowPosixPathInTitle = true;
          };
          NSGlobalDomain."com.apple.trackpad.scaling" = 2.5;
          trackpad.TrackpadThreeFingerDrag = true;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      system.keyboard = {
          enableKeyMapping = true;
          swapLeftCtrlAndFn = true;
      };

      security.pam.enableSudoTouchIdAuth = true;

      system.activationScripts.postUserActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.mirco = {
        name = "mirco";
        home = "/Users/mirco";
      };
}