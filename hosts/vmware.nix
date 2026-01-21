{ pkgs, ... }: {
  imports = [
    ./vmware-hardware.nix
  ];

  home-manager.extraSpecialArgs.isVmware = true;

  networking.hostName = "vmware";

  virtualisation.vmware.guest.enable = true;
  programs.fuse.userAllowOther = true;
  environment.systemPackages = [
    pkgs.open-vm-tools
  ];

  systemd.tmpfiles.rules = [
    "d /mnt/hgfs 0755 root root -"
  ];

  systemd.services.mnt-hgfs = {
    after = [ "vmware.service" "graphical.target" ];
    wants = [ "vmware.service" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.open-vm-tools}/bin/vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other";
      ExecStop = "/run/wrappers/bin/fusermount -u /mnt/hgfs";
    };
  };

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];

  users.users.james.initialPassword = "changeme";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
}
