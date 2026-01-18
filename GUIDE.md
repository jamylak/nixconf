# Docker Nix Home Manager Guide

This guide shows how to build the image from scratch and then iterate on your flake
without rebuilding the image each time.

## Build From Scratch

```sh
docker build -t nixos-test .
```

## Run With Activation (fish shell)

```sh
docker run --rm -it nixos-test
```

You should land in `fish` with your Home Manager config activated.

## Pull Latest Changes in Live Container

```sh
docker run --rm -it --user root -v "$PWD":/workspace --entrypoint sh nixos-test
```

Inside the container:

```sh
git config --global --add safe.directory /workspace
cd /workspace
nix flake lock --update-input nixpkgs --update-input home-manager --update-input nvimconf --update-input dotfiles
nix build --impure .#homeConfigurations.docker.activationPackage
./result/activate
. /home/dev/.nix-profile/etc/profile.d/hm-session-vars.sh
exec /home/dev/.nix-profile/bin/fish
```
