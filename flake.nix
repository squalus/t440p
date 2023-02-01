{
  description = "ThinkPad T440P coreboot";

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  with pkgs;
  {

    packages.x86_64-linux = rec {

      # script from coreboot that extracts firmware from chromeos recovery images
      crosfirmware = callPackage ./crosfirmware {};

      # haswell mrc.bin blob
      haswell-mrc-bin = callPackage ./haswell-mrc-bin { inherit crosfirmware; };

      # coreboot toolchain that can build a t440p rom
      toolchain = callPackage ./toolchain {};

      # grub2 coreboot payload
      grub2 = callPackage ./grub2 {};

      # the final rom that can be flashed
      rom = callPackage ./coreboot {
        inherit grub2 haswell-mrc-bin toolchain;
      };

    };

    nixosModules = rec {
    };

    apps.x86_64-linux = {
    };

    devShells.x86_64-linux.default =
      mkShell {
        name = "shell";
        nativeBuildInputs = [
          pkg-config
          ncurses
          m4
          bison
          flex
          zlib
          self.packages.x86_64-linux.toolchain
          autoconf
          automake
          gettext
          gnulib
          coreboot-utils
        ];
      };
  };
}
