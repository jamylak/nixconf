{ pkgs, ... }: {
  home.username = "dev";
  home.homeDirectory = "/home/dev";

  programs.home-manager.enable = true;

  # Example: install neovim
  home.packages = [
    pkgs.neovim
  ];
}
