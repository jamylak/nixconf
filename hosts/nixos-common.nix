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
  home-manager.users.james = {
    imports = [ ../home.nix ];

    dconf.settings = {
      "org/gnome/shell/keybindings" = {
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
        close = [ "<Super>w" "<Super>q" ];
      };
      "org/gnome/desktop/default-applications/terminal" = {
        exec = "kitty";
        exec-arg = "";
      };
    };
  };
}
