{ ... }: {
  networking.hostName = "vmware";

  virtualisation.vmware.guest.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "vmware" ];
}
