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
    blueman.enable = true;
    dbus.enable = true;
    udev.extraRules = ''
      SUBSYSTEM=="backlight", KERNEL=="intel_backlight", TAG+="systemd", ENV{PREFERRED}="1"
    '';
    gnome = {
      gnome-keyring.enable = true;
    };
  };
  
  security.pam.services.login.enableGnomeKeyring = true;
}
