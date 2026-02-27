{ config, pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      libdrm
      protonup-ng
      mangohud
    ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode.enable = true;

  hardware.nvidia = {
    prime = {
      reverseSync.enable = true;
      #offload = {
      #  enable = true;
      #  enableOffloadCmd = true;
      #};
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };

    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    open = true;
    nvidiaSettings = true; # gui app
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  environment.systemPackages = with pkgs; [
    mesa-demos
  ];

}
