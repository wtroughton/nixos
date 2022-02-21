{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules;

in {
  imports = [
    ../modules/desktop/sway.nix
    ../modules/shell/git.nix
    ../modules/shell/zsh.nix
  ];

  xdg.enable = true;

  modules = {
    desktop = { sway.enable = true; };

    shell = {
      zsh = {
        enable = true;

        loginShellInit = optionalString cfg.desktop.sway.enable ''
          if [ "$(tty)" = "/dev/tty1" ] ; then
            exec sway
          fi
        '';
      };
      git.enable = true;
    };
  };
  fonts.fontconfig.enable = true;
  programs.foot = {
    enable = true;
    server.enable = true;

    settings = { main = { font = "Iosevka Extended:size=12"; }; };
  };

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # fonts
    iosevka
    font-awesome
    tex-gyre.heros

    firefox-wayland

    # terminal emulator
    foot

    htop
  ];
}
