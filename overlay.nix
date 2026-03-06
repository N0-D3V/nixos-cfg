{ inputs, system, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      anifetch = inputs.anifetch.packages.${system}.default.overrideAttrs (old: {
        propagatedBuildInputs =
          (old.propagatedBuildInputs or [ ])
          ++ (with final.python3Packages; [
            wcwidth
            rich
            pynput
          ]);
      });
    })
  ];
}
