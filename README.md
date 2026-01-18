# nixconf
## Build
Run (build validates the flake):

```sh
docker build -t nixos-test .
```

Optional re-check in a fresh container:

```sh
docker run --rm nixos-test
```
