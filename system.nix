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
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      31311
    ];
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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
  };

  # ---------------------------
  # Desktop Environment
  # ---------------------------
  programs.hyprland = {
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        user = "nodev";
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
    material-symbols
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
    papirus-icon-theme
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qt5.qtpositioning
    wl-clipboard
    seahorse
    adwaita-icon-theme
    noto-fonts-cjk-sans

    kdePackages.plasma-systemmonitor
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
