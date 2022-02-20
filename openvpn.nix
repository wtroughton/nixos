# Do not commit to git! This file contains credentials
# for VPN service.

{ config, lib, ... }:

{
  age.secrets.BytzVPN.file = ./secrets/BytzVPN.age;
  age.secrets.BytzVPNAtlanta.file = ./secrets/BytzVPNAtlanta.ovpn.age;
  age.identityPaths = [ "/home/alice/.ssh/id_ed25519" ];

  services.openssh.enable = true;

  services.openvpn.servers = {
    BytzVPNAtlanta = { 
      autoStart = true;
      config = ''
        config ${config.age.secrets.BytzVPNAtlanta.path}
        auth-user-pass ${config.age.secrets.BytzVPN.path}
      '';
    };
  };

  systemd.services.openvpn-reconnect = {
    enable = true;
    description = "Restart OpenVPN after suspend";

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/pkill --signal SIGHUP --exact openvpn";
    };

    wantedBy = [ "sleep.target" ];
  };
}
