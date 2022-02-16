{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules;

in {
  imports = [ ../modules/desktop/sway.nix ../modules/shell/zsh.nix ];

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
    };
  };

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [ pkgs.htop ];
}
