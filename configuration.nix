{ config, pkgs, ... }:

{
  networking.hostName = "HAL";

  imports = [ ./hardware-configuration.nix ];

  # Set time zone
  time.timeZone = "America/New_York";

  # Select internationalization properties
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.alice = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  # Allow nixpkgs to install and search proprietary software 
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11";
}
