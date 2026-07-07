{
  pkgs,
  ...
}:
{
  console.earlySetup = true;

  boot = {
    loader.grub = {
      enable = false;
      efiSupport = true;
      useOSProber = true;
      device = "nodev";
      splashImage = null;
      backgroundColor = "#000000";
      timeoutStyle = "hidden";
    };
    loader.timeout = 5;

    loader.systemd-boot = {
      enable = true;
    };

    loader.efi.canTouchEfiVariables = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelPackages = pkgs.linuxKernel.packages.linux_6_6;
    kernelParams = [
      "quiet"
      "udev.log_level=0"
      "splash"
    ];
    kernelModules = [
      "i2c-dev"
      "i2c-i801"
    ];
    kernel.sysctl."kernel.yama.ptrace_scope" = 0;

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
            "hexagon_dots_alt"
            "hexagon_hud"
            "seal"
            "seal_2"
            "seal_3"
            "spin"
            "splash"
          ];
        })
      ];
    };
  };
}
