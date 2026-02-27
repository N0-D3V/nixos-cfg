{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.fish = {
    enable = true;
  };

  programs.nh = {
    enable = true;
    flake = "/home/nodev/.nixos/";
    clean.enable = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.kdeconnect = {
    enable = true;
  };

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
    theme = spicePkgs.themes.lucid;
  };

  programs.nano.enable = false;

  environment = {
    systemPackages =
      with pkgs;
      with nodePackages_latest;
      with libsForQt5;
      [
        # Daily use
        inputs.zen-browser.packages.x86_64-linux.default
        obsidian
        libreoffice
        localsend
        github-cli
        zapzap
        rnote
        zoom-us
        ente-auth
        proton-pass
        foliate
        discord
        signal-desktop
        github-desktop
        pavucontrol
        gitkraken
        eddie
        qbittorrent
        jellyfin-desktop
        #mpv

        # CLI
        fastfetch
        cbonsai
        yt-dlp
        imagemagick
        playerctl
        wmctrl

        # Tools
        mangohud
        bat
        fd
        fzf
        socat
        jq
        acpi
        ffmpeg
        libnotify
        killall
        zip
        unzip
        glib
        appimage-run
        lsd
        lshw
        bc

        # GNOME
        nautilus
        loupe
        sushi
        baobab
        gnome-system-monitor
        gnome-calculator
        gnome-clocks
        gnome-sound-recorder
        n8n

        lenovo-legion

        # Nix Related
        nixfmt
        nix-output-monitor
        nurl
        nix-prefetch-git
      ];

  };
}
