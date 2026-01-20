{ config, pkgs, lib, nvimconf, dotfiles, fzf-fish, osConfig ? null, ... }:
let
  isNixos = osConfig != null && osConfig.system ? nixos;
in {
  home.username = lib.mkDefault "dev";
  home.homeDirectory = lib.mkDefault "/home/dev";

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
    pkgs.helix
    pkgs.tmux
    pkgs.ripgrep
    pkgs.fd
    pkgs.git
    pkgs.openssh
    pkgs.curl
    pkgs.wget
    pkgs.unzip
    pkgs.zip
    pkgs.xz
    pkgs.gzip
    pkgs.gnutar
  ] ++ lib.optionals isNixos (
    [
      pkgs.alacritty
      pkgs.kitty
      pkgs.ghostty
      pkgs.brave
      pkgs.vlc
    ]
  );

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
