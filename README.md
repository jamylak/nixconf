# nixconf
## Build
Run (build validates Home Manager config):

```sh
docker build -t nixos-test .
```

Optional re-check + activation in a fresh container (drops into a shell):

```sh
docker run --rm -it nixos-test

To poke around inside the container:

```sh
docker run --rm -it --entrypoint sh nixos-test
```
```
