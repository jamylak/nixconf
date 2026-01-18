FROM nixos/nix

# Set up flake-enabled nix inside container
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf

WORKDIR /workspace

COPY . .

# Build Home Manager activation (sanity check)
RUN nix build .#homeConfigurations.dev.activationPackage

# Default to a quick build so `docker run` validates Home Manager config
CMD [ "nix", "build", ".#homeConfigurations.dev.activationPackage" ]
