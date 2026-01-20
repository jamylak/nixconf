{ nvimconf, dotfiles, fzf-fish, pkgs, ... }: {
  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = [

  ];
  program.fish = {
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
  };
  home-manager.users.james = import ../home.nix;
}
