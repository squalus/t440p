{
  description = "ThinkPad T440P coreboot";

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  with pkgs;
  {

    packages.x86_64-linux = rec {
      crosfirmware = callPackage ./crosfirmware {};
      haswell-mrc-bin = callPackage ./haswell-mrc-bin { inherit crosfirmware; };
    };

    nixosModules = rec {
    };

    apps.x86_64-linux = {
    };

    devShells.x86_64-linux.default =
      mkShell {
        name = "shell";
        nativeBuildInputs = [];
      };
  };
}
