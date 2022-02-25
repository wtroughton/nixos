{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.shell.neovim;

in {
  options.modules.shell.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    vimAlias = mkOption {
      type = types.bool;
      default = false;
    };

    lineNumbers = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.neovim ];

    xdg.config."nvim/init.vim".text = ''
      set number
    ''
  };
}
