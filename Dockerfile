FROM nixos/nix

# Set up flake-enabled nix inside container
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf

RUN mkdir -p /home/dev
ENV HOME=/home/dev

WORKDIR /workspace

COPY . .

# Build Home Manager activation (sanity check)
RUN nix build --impure .#homeConfigurations.dev.activationPackage

# Default to a quick build + activation so `docker run` validates config and apply
CMD [ "sh", "-lc", "nix build --impure .#homeConfigurations.dev.activationPackage && ./result/activate" ]
