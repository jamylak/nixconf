{ pkgs, ... }: {
  networking.hostName = "dell";

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = [
    pkgs.amdvlk
  ];
  hardware.opengl.extraPackages32 = [
    pkgs.driversi686Linux.amdvlk
  ];
}
