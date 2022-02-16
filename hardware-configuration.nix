{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p3";
      preLVM = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "net.ifnames=0" "mem_sleep_default=deep" ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c088fc28-a688-4cc2-b1b3-a8c635226a5c";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1AF8-BA4C";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/53a498b9-9fa8-4c9f-bf82-70ce917b1683"; }];

  # Power management
  environment.systemPackages = [ pkgs.acpi ];

  # Enable powertop auto tuning on startup.
  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Enable touchpad support
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
