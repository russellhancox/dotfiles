{
  description = "rah-dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew }:
    let
      # Linux gets no system-level config, just the dotfiles, so it's standalone
      # home-manager. The arches are named after `uname -m` so the shell alias
      # can pick one without branching.
      linuxHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home.nix
          {
            home.username = "rah";
            home.homeDirectory = "/home/rah";
          }
        ];
      };
    in
    {
      # ponytail: one config, reused by every machine. Add a second attr here
      # only when a machine genuinely needs to differ.
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin.nix

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "rah";
              autoMigrate = true; # adopt the existing /opt/homebrew rather than erroring
            };
          }

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Anything already at one of home.nix's paths gets moved aside
            # rather than clobbered. Mostly matters on the first switch, where
            # the old install.sh symlinks are still in place.
            home-manager.backupFileExtension = "hm-bak";
            home-manager.users.rah = import ./home.nix;
          }
        ];
      };

      homeConfigurations = {
        linux-x86_64 = linuxHome "x86_64-linux";
        linux-aarch64 = linuxHome "aarch64-linux";
      };
    };
}
