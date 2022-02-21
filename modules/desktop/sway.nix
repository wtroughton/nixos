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
    xdg.configFile."yambar/config.yml".source = ../../config/sway/yambar.yml;

    home.packages = with pkgs; [ sway yambar ];

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
