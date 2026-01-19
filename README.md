# nixconf
## Build
Run (build validates Home Manager config):

```sh
docker build -t nixos-test .
```

## Hosts

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
