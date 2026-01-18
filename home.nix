{ pkgs, nvimconf, ... }: {
  home.username = "dev";
  home.homeDirectory = "/home/dev";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # Example: install neovim
  home.packages = [
    pkgs.neovim
    pkgs.gnumake
    pkgs.cargo
    pkgs.cmake
  ];

  home.file.".config/nvim".source = nvimconf;
}
