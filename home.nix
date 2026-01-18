{ pkgs, nvimconf, dotfiles, fzf-fish, ... }: {
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
    pkgs.fish
    pkgs.starship
    pkgs.fzf
    pkgs.eza
    pkgs.yazi
    pkgs.lazygit
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file.".config/nvim".source = nvimconf;

  xdg.configFile."fish/config.fish".source = "${dotfiles}/fish/config.fish";
  xdg.configFile."fish/conf.d".source = "${fzf-fish}/conf.d";
  xdg.configFile."fish/functions".source = "${fzf-fish}/functions";
  xdg.configFile."alacritty".source = "${dotfiles}/alacritty";
  xdg.configFile."kitty".source = "${dotfiles}/kitty";
  xdg.configFile."ghostty".source = "${dotfiles}/ghostty";
  xdg.configFile."helix".source = "${dotfiles}/helix";
  xdg.configFile."yazi".source = "${dotfiles}/yazi";
  xdg.configFile."btop/btop.conf".source = "${dotfiles}/btop/btop.conf";
  xdg.configFile."lazygit".source = "${dotfiles}/lazygit";
  xdg.configFile.".yabairc".source = "${dotfiles}/.yabairc";
}
