{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  users.users.nodev = {
    name = "nodev";
    uid = 1000;
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "audio"
      "video"
      "bluetooth"
    ];
    shell = pkgs.fish;
  };
}
