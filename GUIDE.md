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

## Pull latest changes (Experimental)

Start a container with your repo mounted (run as root so Nix can write the store):

```sh
docker run --rm -it --user root -v "$PWD":/workspace --entrypoint sh nixos-test
```

Inside the container, allow Git access to the mounted repo, then rebuild and activate:

```sh
git config --global --add safe.directory /workspace
cd /workspace
nix flake update --update-input nixpkgs --update-input home-manager --update-input nvimconf --update-input dotfiles

# Run activation as root but target the dev profile (avoid HOME fallback)
chown -R root:root /home/dev /nix/var/nix/profiles/per-user/dev

HOME=/home/dev USER=dev LOGNAME=dev \
NIX_PROFILE=/nix/var/nix/profiles/per-user/dev/profile \
NIX_PROFILES=/nix/var/nix/profiles/per-user/dev/profile \
nix build --impure .#homeConfigurations.dev.activationPackage

HOME=/home/dev USER=dev LOGNAME=dev \
NIX_PROFILE=/nix/var/nix/profiles/per-user/dev/profile \
NIX_PROFILES=/nix/var/nix/profiles/per-user/dev/profile \
./result/activate

chown -R 1000:1000 /home/dev /nix/var/nix/profiles/per-user/dev
. /home/dev/.nix-profile/etc/profile.d/hm-session-vars.sh
HOME=/home/dev USER=dev LOGNAME=dev XDG_CONFIG_HOME=/home/dev/.config \
  exec /home/dev/.nix-profile/bin/fish
```

Now your changes are applied without rebuilding the image.

## Pull Latest Changes (Minimal)

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
