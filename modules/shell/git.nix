{ config, lib, pkgs, ... }:
with lib;

let cfg = config.modules.shell.git;

in {
  options.modules.shell.git = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ gitAndTools.gh gitAndTools.git-open ];

    xdg.configFile."git/config".source = ../../config/git/config;
  };
}
