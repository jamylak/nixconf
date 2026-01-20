{
  description = "Minimal NixOS + Home Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvimconf = {
      url = "github:jamylak/nvimconf";
      flake = false;
    };
    dotfiles = {
      url = "github:jamylak/dotfiles";
      flake = false;
    };
    fzf-fish = {
      url = "github:PatrickF1/fzf.fish";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nvimconf, dotfiles, fzf-fish, ... }:
    let
      mkPkgs = system: import nixpkgs { inherit system; };
      hmArgs = {
        inherit nvimconf;
        inherit dotfiles;
        inherit fzf-fish;
      };
      mkHome = { system, homeModule }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [
            ./home.nix
            homeModule
          ];
          extraSpecialArgs = hmArgs;
        };
    in {
      nixosConfigurations = {
        dell = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/nixos-common.nix
            ./hosts/dell.nix
          ];
          specialArgs = hmArgs;
        };
        vmware = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/nixos-common.nix
            ./hosts/vmware.nix
          ];
          specialArgs = hmArgs;
        };
      };

      homeConfigurations = {
        docker = mkHome {
          system = "aarch64-linux";
          homeModule = ./hosts/home-docker.nix;
        };
        mac = mkHome {
          system = "aarch64-darwin";
          homeModule = ./hosts/home-mac.nix;
        };
      };
    };
}
