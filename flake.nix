{
  description = "sross-nix — nix-darwin + home-manager + Homebrew for macOS (Apple Silicon)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs @ { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... }:
    let
      # --- Machine-specific settings ---------------------------------------
      hostname = "VMIT-FMGHQYVHM6";
      username = "sr523";
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs username hostname; };
        modules = [
          ./modules/darwin.nix
          ./modules/homebrew.nix
          ./modules/cuvpn.nix

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false; # set true if you need x86 brews
              user = username;
              # Adopt the existing /opt/homebrew installation instead of
              # having nix-homebrew reinstall it.
              autoMigrate = true;
            };
          }

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # On the first switch, pre-existing hand-written dotfiles (e.g. an
            # old ~/.zshrc / ~/.zprofile) would make home-manager abort with a
            # "would be overwritten" error. Rename them to *.hm-backup instead.
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = { inherit inputs username; };
            home-manager.users.${username} = import ./home/${username}.nix;
          }
        ];
      };

      # Convenience alias so `darwin-rebuild switch --flake .` works without
      # having to pass the hostname explicitly.
      darwinConfigurations.default = self.darwinConfigurations.${hostname};
    };
}
