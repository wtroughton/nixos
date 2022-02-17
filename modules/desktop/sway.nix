{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop.sway;

in {
  options.modules.desktop.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."sway/config".source = ../../config/sway/config;

    home.packages = [ pkgs.sway ];

    systemd.user.targets.sway-session = {
      Unit = {
        Description = "sway compositor session";
        Documentation = [ "man:systemd.special(7)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
    };
  };
}
