{ config, pkgs, lib, nvimconf, dotfiles, ghostty, fzf-fish, chomper, osConfig ? null, ... }:
let
  # Optional module arg; default to false if not provided.
  isVmware = config._module.args.isVmware or false;
  isNixos = osConfig != null && osConfig.system ? nixos;
  isVmwareHost = isVmware || (isNixos && (osConfig.networking.hostName or "") == "vmware");
  ghosttyPkg = ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.username = lib.mkDefault "dev";
  home.homeDirectory = lib.mkDefault "/home/dev";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # Example: install neovim
  home.packages = [
    pkgs.neovide
    pkgs.neovim
    pkgs.vim
    pkgs.gnumake
    pkgs.cargo
    pkgs.rustc
    pkgs.cmake
    pkgs.ninja
    pkgs.starship
    pkgs.fish
    pkgs.fzf
    pkgs.eza
    pkgs.yazi
    pkgs.btop
    pkgs.lazygit
    pkgs.helix
    pkgs.ripgrep
    pkgs.fd
    pkgs.git
    pkgs.gh
    pkgs.openssh
    pkgs.curl
    pkgs.wget
    pkgs.unzip
    pkgs.zip
    pkgs.uv
    pkgs.xz
    pkgs.gzip
    pkgs.gnutar
    pkgs.nodejs
    pkgs.binutils
    pkgs.lldb
    (pkgs.python3.withPackages (ps: [
      ps.debugpy
    ]))
    pkgs.stdenv.cc
    pkgs.zig
    pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
    chomper.packages.${pkgs.stdenv.hostPlatform.system}.default

    # LSPs
    pkgs.zls
    pkgs.clang-tools
    pkgs.lua-language-server
    pkgs.asm-lsp
    pkgs.rust-analyzer
    pkgs.fish-lsp
    pkgs.nodePackages.yaml-language-server
    pkgs.nixd
    pkgs.ty
    pkgs.taplo
    # pkgs.nodePackages.vscode-langservers-extracted
    # pkgs.gopls
    # pkgs.lemminx
    # pkgs.nodePackages.typescript-language-server
    # pkgs.nodePackages.typescript
  ] ++ lib.optionals isNixos (
    [
    pkgs.alacritty
    pkgs.kitty
    ghosttyPkg
    pkgs.brave
    pkgs.vlc
    pkgs.wl-clipboard
    pkgs.rofi
  ]
  ) ++ lib.optionals (!isNixos) [
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      dracula
    ];
    extraConfig = ''
      source-file ${dotfiles}/.tmux.minimal.conf
    '';
  };

  programs.git = {
    enable = true;
    settings = lib.mkIf isVmwareHost {
      safe = {
        directory = "*";
      };
    };
  };

  xdg.configFile."nvim".source = nvimconf;
  xdg.configFile."dotfiles".source = dotfiles;

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
  xdg.configFile."kwinrc".text = lib.mkIf isNixos ''
    [Plugins]
    wobblywindowsEnabled=true
  '';
  xdg.configFile."kwinrc".force = lib.mkIf isNixos true;
  xdg.configFile."kglobalshortcutsrc".text = lib.mkIf isNixos ''
    [kwin]
    Close Window=Meta+Q,none,Close Window
    Overview=none,none,Overview
    Grid View=none,none,Grid View
    Present Windows=none,none,Present Windows
    Present Windows All=none,none,Present Windows All
    Show Desktop=none,none,Show Desktop
    Switch Window Up=none,none,Switch Window Up
    Switch Window Down=none,none,Switch Window Down
    Switch Window Left=none,none,Switch Window Left
    Switch Window Right=none,none,Switch Window Right
    Walk Through Windows=Ctrl+Alt+F,none,Walk Through Windows
    Walk Through Windows (Reverse)=Ctrl+Alt+B,none,Walk Through Windows (Reverse)
  '';
  xdg.configFile."kglobalshortcutsrc".force = lib.mkIf isNixos true;
  xdg.desktopEntries = lib.mkIf isNixos {
    brave-new-window = {
      name = "New Brave Window";
      genericName = "Web Browser";
      comment = "Open a new Brave window";
      exec = "brave --new-window";
      icon = "brave-browser";
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      menu = "rofi -show drun";
      keybindings = let
        mod = "Mod4";
      in {
        "${mod}+q" = "kill";
        "${mod}+space" = "exec rofi -show drun";
        "Ctrl+Alt+space" = "layout toggle stacking splitv";
        "Ctrl+Alt+n" = "workspace next";
        "Ctrl+Alt+p" = "workspace prev";
        "Ctrl+Alt+t" = "floating toggle";
        "Ctrl+Alt+h" = "resize shrink width 50 px";
        "Ctrl+Alt+l" = "resize grow width 50 px";
      };
    };
  };

  home.file."Downloads/.keep".text = "";

  home.activation.createProjDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/proj" ] && [ ! -L "$HOME/proj" ]; then
      mkdir -p "$HOME/proj"
    fi
  '';
}
