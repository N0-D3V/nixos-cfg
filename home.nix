{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.username = "nodev";
  home.homeDirectory = "/home/nodev";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  programs.illogical-impulse = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    kdePackages.qt5compat
    kdePackages.qtdeclarative
    papirus-icon-theme
    adwaita-icon-theme
    noto-fonts-cjk-sans
    #bluez
  ];

  home.sessionVariables = {
    QML2_IMPORT_PATH = "$HOME/.nix-profile/lib/qt-6/qml";
  };

  # Overrides to End4 dots
  xdg.configFile."kitty-custom.conf".text = lib.mkAfter ''
    background_opacity 0.97 
  '';
 
  xdg.configFile."hypr/custom/monitors.conf".text = ''
    monitor=,2560x1600@144,auto,1.25
    misc {
      vfr = 0
      vrr = 0
    }
    xwayland {
      force_zero_scaling = true
    }

  '';

  xdg.configFile."hypr/custom/environment.conf".text = ''
    env = QSG_RENDER_LOOP,threaded
    env = TERMINAL,kitty --listen-on unix:/tmp/kitty --config ${config.xdg.configHome}/kitty/kitty.conf -1
    env = KITTY_CONFIG_DIRECTORY,${config.xdg.configHome}/kitty
  '';

  xdg.configFile."hypr/custom/windowrules.conf".text = ''
    decoration {
      blur {
        enabled = true
        size = 11
        passes = 3
        ignore_opacity = true
      }
    }

    # First override II's global no_blur for kitty
    windowrule = no_blur off, match:class kitty

    # Set opacity so blur shows through  
    windowrule = opacity 0.97 override 0.97 override, match:class kitty
  '';

  xdg.configFile."hypr/hyprland.conf".text = lib.mkAfter ''
    source = custom/monitors.conf
    source = custom/windowrules.conf
    source = custom/environment.conf
  '';

  gtk.iconTheme.name = "Papirus";

  # --------------------------
  # Code
  # --------------------------
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # C# / .NET
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit

        # Python / AI / ML / DL / RL
        ms-python.python
        ms-python.vscode-pylance
        ms-toolsai.jupyter

        # Nix / Linux
        jnoortheen.nix-ide
        mkhl.direnv
        timonwong.shellcheck
        redhat.vscode-yaml

        # Git / Project sanity
        eamodio.gitlens
        mhutchie.git-graph

        # QoL
        usernamehw.errorlens
        christian-kohler.path-intellisense
        editorconfig.editorconfig
      ];

    };
  };
}
