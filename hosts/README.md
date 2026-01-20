# Hosts Guide

## Dell (NixOS)

You must add Dell-specific hardware and boot settings before it will boot.

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
6) Add a bootloader (UEFI example):
   ```nix
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
   ```
   If you want GRUB, set `boot.loader.grub.enable = true;` and configure devices.
7) Set a password or SSH key for your user:
   ```nix
   users.users.james.initialPassword = "changeme";
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

## VMware Fusion (NixOS)

You must add VM-specific hardware and boot settings before it will boot.

Steps:

1) Create a VM and boot from a NixOS installer ISO.
2) Partition and mount your disks under `/mnt`.
3) Generate hardware config:
   ```sh
   nixos-generate-config --root /mnt
   ```
4) Copy `/mnt/etc/nixos/hardware-configuration.nix` into this repo as `hosts/vmware-hardware.nix`.
5) Import it from `hosts/vmware.nix`:
   ```nix
   imports = [ ./vmware-hardware.nix ];
   ```
6) Add a bootloader (UEFI example):
   ```nix
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
   ```
   Or use GRUB if you prefer.
7) Set a password or SSH key for your user:
   ```nix
   users.users.james.initialPassword = "changeme";
   ```
8) (Optional) Enable networking:
   ```nix
   networking.networkmanager.enable = true;
   ```

```sh
sudo mkdir -p /mnt/hgfs
sudo vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other
```

```sh
sudo nixos-rebuild switch --flake ~/nixconf#vmware
```

Then build and install:

```sh
sudo nixos-rebuild switch --flake .#vmware
```
