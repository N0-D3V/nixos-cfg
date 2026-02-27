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
    password = null;
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
