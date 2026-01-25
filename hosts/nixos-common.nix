{ nvimconf, dotfiles, ghostty, fzf-fish, chomper, plasma-manager, pkgs, ... }: {
  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = [

  ];
  programs.fish = {
    enable = true;
  };

  programs.sway = {
    enable = true;
  };

  programs.ssh = {
    # Use Plasma's askpass to avoid conflicts with GNOME seahorse.
    askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  };

  services.kanata = {
    enable = false;
    keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
          lmet
        )

        (defalias
          smspc (tap-hold 200 200 (multi lmet spc) lmet)
        )

        (deflayer base
          @smspc
        )
      '';
    };
  };

  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.sharedModules = [
    plasma-manager.homeModules.plasma-manager
  ];
  home-manager.extraSpecialArgs = {
    inherit nvimconf;
    inherit dotfiles;
    inherit ghostty;
    inherit fzf-fish;
    inherit chomper;
  };
  home-manager.users.james = { config, lib, ... }:
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
      "org/gnome/settings-daemon/plugins/media-keys" = {
        rotate-video-lock-static = [];
      };
      "org/gnome/desktop/input-sources" = {
        xkb-options = [];
      };
      "org/gnome/shell/keybindings" = {
        open-application-menu = [];
        focus-active-notification = [];
        toggle-message-tray = [];
        show-clipboard = [];
        show-all-apps = [];
        toggle-application-view = [];
        toggle-overview = [ "<Super>space" ];
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
        activate-window-menu = [];
        hide = [];
        minimize = [];
        close = [ "<Super>q" ];
        switch-input-source = [];
        switch-input-source-backward = [];
      };
      "org/gnome/desktop/peripherals/keyboard" = {
        delay = lib.hm.gvariant.mkUint32 168;
        repeat-interval = lib.hm.gvariant.mkUint32 23;
      };
      "org/gnome/desktop/default-applications/terminal" = {
        exec = "kitty";
        exec-arg = "";
      };
    };
  };
}
