{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  # ----------------------------
  # Networking
  # ----------------------------

  networking.hostName = "nixos";
  networking.networkmanager = {
    enable = true;
    plugins = [
      pkgs.networkmanager-openvpn
    ];
  };

  services.openvpn.servers = {
    airvpn = {
      config = "config ${./vpn/airvpn.ovpn}";
      autoStart = false;
    };
  };

  #security.polkit.extraConfig = ''
  #  polkit.addRule(function(action, subject) {
  #    if (
  #      action.id == "org.freedesktop.systemd1.manage-units" &&
  #      action.lookup("unit") == "openvpn-airvpn.service" &&
  #      subject.user == "nodev"
  #    ) {
  #      return polkit.Result.YES;
  #    }
  #  });
  #'';
  # Add back in if you want no authenticator for vpn keybind

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      443
      80
      53317 # for localsend
      8000
    ];
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ];
  };

  services.resolved = {
    enable = true;
    settings.Resolve.DNS = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Policy = {
        AutoEnable = true;
      };
      General = {
        FastConnectable = true;
      };
    };
  };

  # ---------------------------
  # Audio
  # ---------------------------
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  # ---------------------------
  # Desktop Environment
  # ---------------------------
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    app2unit
    libcava
    networkmanager
    lm_sensors
    aubio
    nerd-fonts.caskaydia-cove
    swappy
    libqalculate
    hyprpicker
    cliphist
    trash-cli
    fastfetch
    starship
    btop
    jq
    eza
    adw-gtk3
    libsForQt5.qt5ct
    kdePackages.qt6ct
    qt5.qtpositioning
    wl-clipboard
    adwaita-icon-theme
  ];

  fonts.packages = with pkgs; [
    rubik
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    font-awesome
    material-symbols
    material-design-icons
    noto-fonts-cjk-sans
    noto-fonts
    noto-fonts-color-emoji
  ];

  # ---------------------------
  # Nix
  # ---------------------------

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # --------------------------
  # Locale
  # --------------------------
  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  console.keyMap = "trq";

  # --------------------------
  # Miscellaneous
  # --------------------------

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  documentation.nixos.enable = false;

  system.stateVersion = "24.05";
}
