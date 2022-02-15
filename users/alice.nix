{ config, pkgs, ... }:

{
  # imports = [
  #   profiles/apps/media.nix
  #   profiles/alacritty.nix
  # ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.homeDirectory = "/home/alice";

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.htop
  ];
}
