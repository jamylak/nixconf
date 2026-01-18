{ nvimconf, dotfiles, fzf-fish, ... }: {
  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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
