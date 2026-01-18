FROM nixos/nix

# Enable flakes and nix-command in the container
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf

# Create a dev user entry and home directory (base image has no useradd)
RUN mkdir -p /home/dev && \
    if ! grep -q '^dev:' /etc/passwd; then \
      echo 'dev:x:1000:1000:dev:/home/dev:/bin/sh' >> /etc/passwd; \
    fi && \
    if ! grep -q '^dev:' /etc/group; then \
      echo 'dev:x:1000:' >> /etc/group; \
    fi
# Set expected user environment for Home Manager
ENV HOME=/home/dev
ENV USER=dev
ENV LOGNAME=dev
# Create profile dirs Home Manager expects and grant ownership
RUN mkdir -p /home/dev/.local/state/nix/profiles \
    /nix/var/nix/profiles/per-user/dev && \
    chown -R 1000:1000 /home/dev /nix/var/nix/profiles/per-user/dev

# Work from the repo root inside the image
WORKDIR /workspace

# Copy flake into the image
COPY . .

# Build the Home Manager activation package (sanity check)
RUN nix build --impure .#homeConfigurations.dev.activationPackage

# Run as the dev user for activation and shell
USER dev
# Activate the already-built Home Manager generation, load session vars, then drop into a shell
CMD [ "sh", "-lc", "./result/activate && . /home/dev/.nix-profile/etc/profile.d/hm-session-vars.sh && exec sh" ]
