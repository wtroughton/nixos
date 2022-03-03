{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules;

in {
  imports = [
    ../modules/browser/firefox.nix
    ../modules/desktop/sway.nix
    ../modules/shell/git.nix
    ../modules/shell/neovim.nix
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

        shellAliases = {
          ls = "ls --color=auto";
          vim = "nvim";
        };
      };

      git.enable = true;
      neovim.enable = true;
    };

    browser.firefox.enable = true;
  };

  programs.foot = {
    enable = true;
    server.enable = true;

    settings = { main = { font = "Iosevka Extended:size=12"; }; };
  };

  programs.zathura.enable = true;

  gtk = {
    enable = true;
    iconTheme = { 
      name = "hicolor";
      package = pkgs.hicolor_icon_theme;
    };
  };

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    castor

    # terminal emulator
    foot
    fuzzel

    htop

    kiwix
    mdbook

    spotify

    # ConTeXt typesetting engine
    texlive.combined.scheme-context
  ];
}
