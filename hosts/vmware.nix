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

  fileSystems."/mnt/hgfs" = {
    device = ".host:/";
    fsType = "fuse.vmhgfs-fuse";
    options = [
      "allow_other"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10"
      "x-systemd.mount-timeout=10"
    ];
  };

  systemd.services.mnt-hgfs = {
    after = [ "vmware.service" ];
    wants = [ "vmware.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
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
