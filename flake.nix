{
  description = "Minimal NixOS + Home Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvimconf = {
      url = "github:jamylak/nvimconf";
      flake = false;
    };
    dotfiles = {
      url = "github:jamylak/dotfiles";
      flake = false;
    };
    ghostty = {
      url = "github:ghostty-org/ghostty?rev=9ec6e9ea9a8a590fd906a0d216133d949581f54b";
    };
    fzf-fish = {
      url = "github:PatrickF1/fzf.fish";
      flake = false;
    };
    chomper = {
      url = "github:jamylak/chomper";
    };
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, nvimconf, dotfiles, ghostty, fzf-fish, chomper, ... }:
    let
      mkPkgs = system: import nixpkgs { inherit system; };
      hmArgs = {
        inherit nvimconf;
        inherit dotfiles;
        inherit ghostty;
        inherit fzf-fish;
        inherit chomper;
        inherit plasma-manager;
      };
      mkHome = { system, homeModule }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [
            plasma-manager.homeModules.plasma-manager
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
          system = builtins.currentSystem;
          homeModule = ./hosts/home-docker.nix;
        };
        mac = mkHome {
          system = builtins.currentSystem;
          homeModule = ./hosts/home-mac.nix;
        };
      };
    };
}
