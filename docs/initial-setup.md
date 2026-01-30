# Initial VM Setup Notes

Context (saved from my session):
- NixOS minimal install on a VM in VMware Fusion.
- 45GB of available space.
- Logged in as root via `sudo su` and set a root password.

Bootstrap flow (host commands unless noted):
1) On the VM (ISO environment), get the IP:
   - `ip a`
2) From the host (repo root), run the bootstrap installer (replace with VM IP):
```
make vm/bootstrap0 NIXADDR=192.168.x.x
```
3) After reboot, apply your nixconf to the VM:
   - `make vm/bootstrap NIXADDR=192.168.x.x`
   - This runs `vm/copy` and `vm/switch` to use your flake.

Reference:
- https://www.youtube.com/watch?v=ubDMLoWz76U

Debugging
- If something messes up can reset stuff:
  - `umount -R /mnt || true`
  - `swapoff -a || true`
  - `wipefs -a /dev/nvme0n1`
  - Then rerun `make vm/bootstrap0 NIXADDR=192.168.x.x`
- https://raw.githubusercontent.com/mitchellh/nixos-config/refs/heads/main/Makefile

Next Steps:

1. `ip a`
   # Example IP: 192.168.92.128

2. `ssh root@192.168.92.128`

3. 
