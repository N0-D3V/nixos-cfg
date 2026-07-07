{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  programs.seahorse.enable = true;

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
      adblock
      hidePodcasts
      shuffle
      romajiConvert
    ];
    theme = spicePkgs.themes.matte; # #lucid; Lucid got nuked somehow, check progress on #354 on Gerg-L spicetify every now and then :|
  };

  programs.nano.enable = false;

  environment = {
    systemPackages =
      with pkgs;
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
        foliate
        discord
        signal-desktop
        github-desktop
        pavucontrol
        gitkraken
        qbittorrent
        jellyfin-desktop
        #bitwarden-desktop apparently none of my apps work properly now, this uses an eol electron version, check back later
        papers
        #mpv
        bat
        fd
        fzf
        ripgrep
        claude-code
        shadps4

        prismlauncher

        heroic

        # CLI
        cbonsai
        yt-dlp
        imagemagick
        playerctl
        wmctrl
        anifetch # overlay of a nix flake
        toilet
        lolcat

        # Tools
        mangohud
        socat
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
        file
        linuxPackages.cpupower

        # GNOME
        nautilus
        loupe
        sushi
        baobab
        gnome-system-monitor
        gnome-calculator
        gnome-clocks
        gnome-sound-recorder
        snapshot

        n8n

        # Nix Related
        nixfmt
        nix-output-monitor
        nurl
        nix-prefetch-git

        # Development
        uv
      ];
  };
  nix.settings = {
    trusted-users = [
      "root"
      "nodev"
    ];

    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];

  };
}
