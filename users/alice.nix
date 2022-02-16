{ config, pkgs, ... }:

{
  imports = [ ../modules/desktop/sway.nix ];

  modules = {
    desktop = {
      sway.enable = true;
    };
  };

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.htop
  ];
}
