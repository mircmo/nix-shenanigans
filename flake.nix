{
  description = "Mirco's system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
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

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.mirco = {
        name = "mirco";
        home = "/Users/mirco";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Mircos-MacBook-Pro
    darwinConfigurations."Mircos-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mirco = import ./home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Mircos-MacBook-Pro".pkgs;
  };
}
