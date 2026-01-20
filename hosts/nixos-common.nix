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
  home-manager.users.james = import ../home.nix;
}
