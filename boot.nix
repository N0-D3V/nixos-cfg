{
  pkgs,
  ...
}:
{
  console.earlySetup = false;

  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      useOSProber = true;
      device = "nodev";
      splashImage = null;
      backgroundColor = "#000000";
      timeoutStyle = "hidden";
    };
    loader.timeout = 1;

    loader.efi.canTouchEfiVariables = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelPackages = pkgs.linuxKernel.packages.linux_6_6;
    kernelParams = [
      "quiet"
      "splash"
    ];
    kernelModules = [
      "i2c-dev"
      "i2c-i801"
    ];

    plymouth = {
      enable = true;
      theme = "hexagon_dots";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [
            "dna"
            "hexagon_dots"
            "angular_alt"
            "double"
            "glitch"
            "hexagon_dots_alt"
            "hexagon_hud"
            "infinite_seal"
            "seal"
            "seal_2"
            "seal_3"
            "spin"
            "splash"
            "tech_a"
          ];
        })
      ];
    };
  };
}
