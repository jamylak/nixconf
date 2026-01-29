# nixconf

## Setup

Quick start (NixOS):

```sh
git clone <this repo>
cd nixconf
sudo nixos-rebuild switch --flake .#<host>
```

Example (VMware):

```sh
sudo nixos-rebuild switch --flake ~/nixconf#vmware
```

Home Manager (non-NixOS / standalone):

```sh
nix build --impure .#homeConfigurations.<name>.activationPackage
./result/activate
```

Host-specific details (hardware configs, bootloader, etc.) live in `hosts/README.md`.



## Docker Host (old)

I was just quickly testing this inside of Docker as a quick validation before using a VM.
It may no longer work in Docker though

### Build
Run (build validates Home Manager config):

```sh
docker build -t nixos-test .
```

### Hosts

See `hosts/README.md` for Dell and VMware setup.

Optional re-check + activation in a fresh container (drops into fish):

```sh
docker run --rm -it nixos-test
```

To poke around inside the container (fish):

```sh
docker run --rm -it --entrypoint sh nixos-test -lc ". /home/dev/.nix-profile/etc/profile.d/hm-session-vars.sh && exec /home/dev/.nix-profile/bin/fish"
```

Live edit + refresh without rebuilding the image (fish):

```sh
docker run --rm -it -v "$PWD":/workspace --entrypoint sh nixos-test -lc "exec /home/dev/.nix-profile/bin/fish"
```

Inside the container (after activation, fish will be on PATH):

```sh
cd /workspace
nix build --impure .#homeConfigurations.docker.activationPackage
./result/activate
. /home/dev/.nix-profile/etc/profile.d/hm-session-vars.sh
```
