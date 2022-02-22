{ config, pkgs, inputs, ... }:

let inherit (inputs) agenix;

in {
  networking.hostName = "HAL";

  imports = [ ./hardware-configuration.nix ./openvpn.nix ];

  # Set time zone
  time.timeZone = "America/New_York";

  # Select internationalization properties
  i18n.defaultLocale = "en_US.UTF-8";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlan0.useDHCP = true;
  networking.networkmanager.enable = true;

  # rtkit is optional but recommended for pipewire performance
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users = { 
    alice = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
    };

    lee = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
    };
  };

  # Enabling zsh system-wide allows it to source necessary files
  # e.g. autocompletion, docs
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    agenix.defaultPackage.x86_64-linux
    brightnessctl
    pulseaudio

    git
    unzip
    vim
    wget
  ];

  # System fonts
  fonts = {
    fontconfig.enable = true;

    fonts = with pkgs; [
      font-awesome
      ibm-plex
      inter
      iosevka
      roboto
      tex-gyre.heros
    ];
  };

  # Set Vim as default editor
  environment.variables.EDITOR = "vim";

  # Sway requires OpenGL enabled for MESA drivers
  # https://github.com/NixOS/nixpkgs/issues/94315
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

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
