{ pkgs, lib, ... }:
{
  home.username = "nodev";
  home.homeDirectory = "/home/nodev";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  programs.illogical-impulse.enable = true;
  
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    kdePackages.qt5compat
    kdePackages.qtdeclarative
    papirus-icon-theme
    adwaita-icon-theme
  ];

  home.sessionVariables = {
    QML2_IMPORT_PATH = "$HOME/.nix-profile/lib/qt-6/qml";
  };
  
  # Overrides to End4 dots
  xdg.configFile."hypr/custom/monitors.conf".text = ''
    monitor=,2560x1600@144,auto,1.25
    misc {
      vfr = false
    }
    xwayland {
      force_zero_scaling = true
    }

  '';

  xdg.configFile."hypr/custom/env.conf".text = ''
     env = QSG_RENDER_LOOP,threaded
  ''; 

  xdg.configFile."hypr/hyprland.conf".text = lib.mkAfter ''
    source = custom/monitors.conf
  '';

  

  gtk.iconTheme.name = "Papirus";
}
