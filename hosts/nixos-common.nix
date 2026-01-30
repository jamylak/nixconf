{
  nvimconf,
  dotfiles,
  ghostty,
  fzf-fish,
  chomper,
  plasma-manager,
  xremap,
  pkgs,
  ...
}:
{
  system.stateVersion = "24.05";
  time.timeZone = "Australia/Sydney";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = [

  ];
  programs.fish = {
    enable = true;
  };

  programs.sway.enable = false;

  programs.ssh = {
    # Use Plasma's askpass to avoid conflicts with GNOME seahorse.
    askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  };

  # Unlock KWallet at login
  security.pam.services = {
    sddm.kwallet.enable = true;
    login.kwallet.enable = true;
    sddm.kwallet.package = pkgs.kdePackages.kwallet-pam;
    login.kwallet.package = pkgs.kdePackages.kwallet-pam;
  };

  services.kanata = {
    enable = false; # temporarily disable to let xremap grab the keyboard
  };

  services.udev.extraRules = ''
    # Allow xremap to write to /dev/uinput without running as root.
    ACTION=="add|change", SUBSYSTEM=="misc", KERNEL=="uinput", GROUP="uinput", MODE="0660", OPTIONS+="static_node=uinput"
  '';

  users.users.james = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input" # xremap reads physical devices from /dev/input/event*
      "uinput" # xremap writes remapped keys via /dev/uinput
    ];
    shell = pkgs.fish;
  };

  users.groups.uinput = { };

  boot.kernelModules = [ "uinput" ]; # ensure /dev/uinput exists for xremap

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.sharedModules = [
    plasma-manager.homeModules.plasma-manager
    xremap.homeManagerModules.default
  ];
  home-manager.extraSpecialArgs = {
    inherit nvimconf;
    inherit dotfiles;
    inherit ghostty;
    inherit fzf-fish;
    inherit chomper;
  };
  home-manager.users.james =
    { config, lib, ... }:
    let
      homeDir = config.home.homeDirectory;
      localNvimconf = "${homeDir}/proj/nvimconf";
      localDotfiles = "${homeDir}/proj/dotfiles";
    in
    {
      imports = [ ../home.nix ];

      # Use ~/proj/nvimconf or ~/proj/dotfiles
      # when they exist for config
      xdg.configFile."nvim".source =
        if builtins.pathExists localNvimconf then
          config.lib.file.mkOutOfStoreSymlink localNvimconf
        else
          nvimconf;

      xdg.configFile."fish/config.fish".source =
        if builtins.pathExists "${localDotfiles}/fish/config.fish" then
          config.lib.file.mkOutOfStoreSymlink "${localDotfiles}/fish/config.fish"
        else
          "${dotfiles}/fish/config.fish";

    };
}
