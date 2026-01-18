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

## Live Edit Without Rebuilding

Start a container with your repo mounted (run as root so Nix can write the store):

```sh
docker run --rm -it --user root -v "$PWD":/workspace --entrypoint sh nixos-test
```

Inside the container, allow Git access to the mounted repo, then rebuild and activate:

```sh
git config --global --add safe.directory /workspace
cd /workspace
nix build --impure .#homeConfigurations.dev.activationPackage
./result/activate
. /home/dev/.nix-profile/etc/profile.d/hm-session-vars.sh
exec /home/dev/.nix-profile/bin/fish
```

Now your changes are applied without rebuilding the image.

## Pull Latest Dotfiles

Your dotfiles input is pinned in `flake.lock`. To update it to the latest
commit and re-apply:

```sh
docker run --rm -it --user root -v "$PWD":/workspace --entrypoint sh nixos-test
```

Inside the container:

```sh
git config --global --add safe.directory /workspace
cd /workspace
nix flake lock --update-input nixpkgs --update-input home-manager --update-input nvimconf --update-input dotfiles
nix build --impure .#homeConfigurations.dev.activationPackage
./result/activate
. /home/dev/.nix-profile/etc/profile.d/hm-session-vars.sh
exec /home/dev/.nix-profile/bin/fish
```
