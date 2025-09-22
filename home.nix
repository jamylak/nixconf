{ pkgs, ... }: {
  home.username = "dev";
  home.homeDirectory = "/home/dev";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # Example: install neovim
  home.packages = [
    pkgs.neovim
  ];
}
