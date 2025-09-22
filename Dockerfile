FROM nixos/nix

# Set up flake-enabled nix inside container
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf

WORKDIR /workspace

COPY . .

# Build minimal system closure (sanity check)
RUN nix build .#nixosConfigurations.minimal.config.system.build.toplevel

# Drop into shell with dev's home-manager environment
CMD [ "nix", "run", ".#homeConfigurations.dev.activationPackage" ]
