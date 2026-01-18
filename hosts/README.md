## Hosts

- NixOS: `nixosConfigurations.dell` (x86_64-linux, GNOME, AMD Vulkan)
- NixOS: `nixosConfigurations.vmware` (aarch64-linux, GNOME, VMware guest)
- Home Manager: `homeConfigurations.docker` (Docker test target)
- Home Manager: `homeConfigurations.mac` (macOS user in `hosts/home-mac.nix`)

## Dell Setup (NixOS)

You must add Dell-specific hardware and boot settings before this will boot.

Steps:

1) Boot the Dell from a NixOS installer USB.
2) Partition and mount your disks under `/mnt`.
3) Generate hardware config:
   ```sh
   nixos-generate-config --root /mnt
   ```
4) Copy `/mnt/etc/nixos/hardware-configuration.nix` into this repo as `hosts/dell-hardware.nix`.
5) Import it from `hosts/dell.nix`:
   ```nix
   imports = [ ./dell-hardware.nix ];
   ```
6) Add a bootloader for the Dell (UEFI example):
   ```nix
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
   ```
   If you want GRUB, set `boot.loader.grub.enable = true;` and configure devices.
7) Set a password or SSH key for your user:
   ```nix
   users.users.dev.initialPassword = "changeme";
   ```
   or use `openssh.authorizedKeys.keys`.
8) (Optional) Enable networking:
   ```nix
   networking.networkmanager.enable = true;
   ```

Then build and install:

```sh
sudo nixos-rebuild switch --flake .#dell
```

