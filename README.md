# nixconf
## Build
Run (build validates Home Manager config):

```sh
docker build -t nixos-test .
```

Optional re-check in a fresh container:

```sh
docker run --rm nixos-test
```
