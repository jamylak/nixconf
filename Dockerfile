FROM nixos/nix

# Enable flakes and nix-command in the container
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf

# Create a home dir for the dev user
RUN mkdir -p /home/dev
# Set expected user environment for Home Manager
ENV HOME=/home/dev
ENV USER=dev
ENV LOGNAME=dev
# Create profile dirs Home Manager expects
RUN mkdir -p /home/dev/.local/state/nix/profiles \
    /nix/var/nix/profiles/per-user/dev

# Work from the repo root inside the image
WORKDIR /workspace

# Copy flake into the image
COPY . .

# Build the Home Manager activation package (sanity check)
RUN nix build --impure .#homeConfigurations.dev.activationPackage

# Build + activate at runtime, then drop into a shell
CMD [ "sh", "-lc", "nix build --impure .#homeConfigurations.dev.activationPackage && ./result/activate && exec sh" ]
