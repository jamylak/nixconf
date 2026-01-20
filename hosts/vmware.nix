{ ... }: {
  imports = [
    ./vmware-hardware.nix
  ];

  networking.hostName = "vmware";

  virtualisation.vmware.guest.enable = true;

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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];

  users.users.james.initialPassword = "changeme";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
}
