{
  description = "Minimal NixOS + Home Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = builtins.currentSystem;
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.minimal = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            system.stateVersion = "24.05"; # REQUIRED
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            users.users.dev = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              initialPassword = "dev";
            };
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.dev = import ./home.nix;
          }
        ];
      };

      homeConfigurations.dev = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };
    };
}
