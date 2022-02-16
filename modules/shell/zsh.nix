{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.shell.zsh;

in {
  options.modules.shell.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    loginShellInit = mkOption {
      default = "";
      description = ''
        Shell script code called during zsh login shell initialization.
      '';
      type = types.lines;
    };
  };

  config = mkIf cfg.enable {
    home.file.".zlogin".text = ''
      ${cfg.loginShellInit}
    '';
  };
}
