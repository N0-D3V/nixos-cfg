{ pkgs, inputs, ... }:
{
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
    printing.enable = true;
    geoclue2.enable = true; # For QtPositioning
    upower.enable = true;
    power-profiles-daemon.enable = true;
    thermald.enable = true;
    #blueman.enable = true;
    dbus.enable = true;
    udisks2.enable = true;
    gnome = {
      gnome-keyring.enable = true;
    };
    gvfs.enable = true;
    tumbler.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;
}
