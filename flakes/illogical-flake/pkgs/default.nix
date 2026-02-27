{ pkgs }:
let
  pythonDeps = {
    buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
    fetchFromGitHub = pkgs.fetchFromGitHub;
    setuptools = pkgs.python3Packages.setuptools;
    dbus-python = pkgs.python3Packages."dbus-python";
    numpy = pkgs.python3Packages.numpy;
    pillow = pkgs.python3Packages.pillow;
    materialyoucolor = pkgs.python3Packages.materialyoucolor;
    python-magic = pkgs.python3Packages."python-magic";
  };
in
{
  illogical-impulse-oneui4-icons = pkgs.callPackage ./illogical-impulse-oneui4-icons { };
  material-symbols = pkgs.callPackage ./material-symbols { };
  kde-material-you-colors = pkgs.callPackage ./kde-material-you-colors pythonDeps;
  brightnessctl = pkgs.symlinkJoin {
    name = "brightnessctl";
    paths = [ pkgs.brightnessctl ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/brightnessctl \
        --add-flags "-d 'intel_backlight'"
    '';
  }; # Fixes brightnessctl changing nvidia_0 backlight and not affecting actual brightness
}
