# https://github.com/mitchellh/nixos-config/blob/main/Makefile
# Makefile for jamylak/nixconf
# Connectivity info for Linux VM
NIXADDR ?= unset
NIXPORT ?= 22
NIXUSER ?= james
SWAP_SIZE ?= 4GB
# Disk device for the VM (VMware NVMe by default).
# If your VM uses SATA/SCSI, set DISK=/dev/sda and PART_SUFFIX=.
DISK ?= /dev/nvme0n1
PART_SUFFIX ?= p

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# The name of the nixosConfiguration in the flake
NIXNAME ?= vmware-m1
HARDWARE_FILE ?= hosts/$(NIXNAME)-hardware.nix

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

switch:
	sudo NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --impure --flake ".#${NIXNAME}"

test:
	sudo NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild test --impure --flake ".#$(NIXNAME)"

# bootstrap a brand new VM. The VM should have NixOS ISO on the CD drive
# and just set the password of the root user to "root". This will install
# NixOS. After installing NixOS, you must reboot and set the root password
# for the next step.
#
# in one step but when I tried to merge them I got errors. One day.
vm/bootstrap0:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) " \
		parted $(DISK) -- mklabel gpt; \
		parted $(DISK) -- mkpart primary 512MB -$(SWAP_SIZE); \
		parted $(DISK) -- mkpart primary linux-swap -$(SWAP_SIZE) 100\%; \
		parted $(DISK) -- mkpart ESP fat32 1MB 512MB; \
		parted $(DISK) -- set 3 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos $(DISK)$(PART_SUFFIX)1; \
		mkswap -L swap $(DISK)$(PART_SUFFIX)2; \
		mkfs.fat -F 32 -n boot $(DISK)$(PART_SUFFIX)3; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		nixos-generate-config --root /mnt; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.package = pkgs.nixVersions.latest;\n \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
  			services.openssh.enable = true;\n \
			services.openssh.settings.PasswordAuthentication = true;\n \
			services.openssh.settings.PermitRootLogin = \"yes\";\n \
			users.users.root.initialPassword = \"root\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		echo \"nameserver 1.1.1.1\" > /etc/resolv.conf; \
		echo \"nameserver 8.8.8.8\" >> /etc/resolv.conf; \
		nixos-install --no-root-passwd && reboot; \
	"

# after bootstrap0, run this to finalize. After this, do everything else
# in the VM unless secrets change.
vm/bootstrap:
	$(MAKE) vm/hardware
	NIXUSER=root $(MAKE) vm/copy
	NIXUSER=root $(MAKE) vm/switch

# copy the Nix configurations into the VM.
vm/copy:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='vendor/' \
		--exclude='.git/' \
		--exclude='.git-crypt/' \
		--exclude='.jj/' \
		--exclude='iso/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/nixconf

# copy the generated hardware config into the repo
vm/hardware:
	scp -P $(NIXPORT) $(SSH_OPTIONS) root@$(NIXADDR):/etc/nixos/hardware-configuration.nix $(MAKEFILE_DIR)/$(HARDWARE_FILE)

# run the nixos-rebuild switch command. This does NOT copy files so you
# have to run vm/copy before.
vm/switch:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake \"/nixconf#${NIXNAME}\" \
	"
