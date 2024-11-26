{ pkgs, self, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
          pkgs.vim
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
          hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";
          
          # This option somehow doesn't work
          # universalaccess.closeViewScrollWheelToggle = true;
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
      nix = {
        package = pkgs.nix;
        settings.experimental-features = "nix-command flakes";
        linux-builder.enable = true;
        settings.trusted-users = [ "@admin" ];
      };
      # Necessary for using flakes on this system.

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

      homebrew = {
        enable = true;
        casks = [
          "proton-mail"
        ];
      };
}
