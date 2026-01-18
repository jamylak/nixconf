#!/usr/bin/env bash
set -euo pipefail

mkdir -p nixos-flake
cd nixos-flake

# flake.nix
cat > flake.nix <<'EOF'
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
  };

  outputs = { self, nixpkgs, home-manager, nvimconf, ... }:
    let
      system = builtins.currentSystem;
    in {
      nixosConfigurations.minimal = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ pkgs, ... }: {
            # Minimal NixOS base
            services.getty.autologin = {
              enable = true;
              user = "dev";
            };

            users.users.dev = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              initialPassword = "dev";
            };

            # Enable flakes
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = {
              inherit nvimconf;
            };
            home-manager.users.dev = import ./home.nix;
          }
        ];
      };
    };
}
EOF

# home.nix
cat > home.nix <<'EOF'
{ pkgs, nvimconf, ... }: {
  home.username = "dev";
  home.homeDirectory = "/home/dev";

  programs.home-manager.enable = true;

  # Example: install neovim
  home.packages = [
    pkgs.neovim
  ];

  home.file.".config/nvim".source = nvimconf;
}
EOF

# Dockerfile
cat > Dockerfile <<'EOF'
FROM nixos/nix

# Set up flake-enabled nix inside container
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf

RUN mkdir -p /home/dev
ENV HOME=/home/dev
ENV USER=dev
ENV LOGNAME=dev

WORKDIR /workspace

COPY . .

# Build Home Manager activation (sanity check)
RUN nix build --impure .#homeConfigurations.dev.activationPackage

# Default to a quick build + activation, then drop into a shell
CMD [ "sh", "-lc", "nix build --impure .#homeConfigurations.dev.activationPackage && ./result/activate && exec sh" ]
EOF

echo "Repo created in $(pwd). Run 'docker build -t nixos-test .' then 'docker run --rm nixos-test'."
