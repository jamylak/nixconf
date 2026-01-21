{ nvimconf, dotfiles, fzf-fish, ghostty, pkgs, ... }: {
  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = [

  ];
  programs.fish = {
    enable = true;
  };

  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit nvimconf;
    inherit dotfiles;
    inherit fzf-fish;
    inherit ghostty;
  };
  home-manager.users.james = { config, ... }:
    let
      homeDir = config.home.homeDirectory;
      localNvimconf = "${homeDir}/proj/nvimconf";
      localDotfiles = "${homeDir}/proj/dotfiles";
    in {
    imports = [ ../home.nix ];

    # Use ~/proj/nvimconf or ~/proj/dotfiles
    # when they exist for config
    xdg.configFile."nvim".source =
      if builtins.pathExists localNvimconf
      then config.lib.file.mkOutOfStoreSymlink localNvimconf
      else nvimconf;

    xdg.configFile."fish/config.fish".source =
      if builtins.pathExists "${localDotfiles}/fish/config.fish"
      then config.lib.file.mkOutOfStoreSymlink "${localDotfiles}/fish/config.fish"
      else "${dotfiles}/fish/config.fish";

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [];
      };
      "org/gnome/shell/keybindings" = {
        open-application-menu = [];
        focus-active-notification = [];
        toggle-message-tray = [];
        show-clipboard = [];
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
        switch-to-application-5 = [];
        switch-to-application-6 = [];
        switch-to-application-7 = [];
        switch-to-application-8 = [];
        switch-to-application-9 = [];
      };
      "org/gnome/desktop/wm/keybindings" = {
        hide = [];
        close = [ "<Super>q" ];
      };
      "org/gnome/desktop/default-applications/terminal" = {
        exec = "kitty";
        exec-arg = "";
      };
    };
  };
}
