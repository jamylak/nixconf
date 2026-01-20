{ ... }: {
  imports = [
    ./vmware-hardware.nix
  ];

  networking.hostName = "vmware";

  virtualisation.vmware.guest.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "vmware" ];

  users.users.james.initialPassword = "changeme";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
}
