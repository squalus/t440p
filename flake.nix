{
  description = "ThinkPad T440P coreboot";

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    libreboot-pins = builtins.fromJSON (builtins.readFile ./libreboot.json);
  in
  with pkgs;
  {

    packages.x86_64-linux = rec {

      # script from coreboot that extracts mrc.bin from chromeos recovery images
      crosfirmware = callPackage ./crosfirmware {};

      # mrc.bin blob
      mrc = callPackage ./mrc.nix { inherit crosfirmware; };

      # grub compiled with coreboot support
      grub-coreboot = callPackage ./grub.nix {
        gnulib-src = fetchgit libreboot-pins.gnulib;
        src = fetchgit libreboot-pins.grub;
      };

      # grub coreboot payload
      grub-payload = callPackage ./grub-payload { inherit grub-coreboot; };

      # libreboot's pinned rev of me_cleaner
      me_cleaner = pkgs.me_cleaner.overrideAttrs (old: {
        src = fetchFromGitHub libreboot-pins.me_cleaner;
      });

      # lbmk source code
      libreboot = fetchgit libreboot-pins.libreboot;

      # cleaned intel me rom
      me = callPackage ./me.nix {};

      # function to build a payload-free coreboot image
      mkCoreboot = callPackage ./coreboot/mkCoreboot.nix {};

      # coreboot image for the t440p device
      coreboot-t440p = callPackage ./coreboot/t440p.nix {
        inherit libreboot me mkCoreboot mrc;
      };

      # the final rom with an embedded grub payload. can be flashed directly to the device.
      rom = callPackage ./rom.nix {
        inherit grub-payload;
        coreboot = coreboot-t440p;
      };
    };

    devShells.x86_64-linux.default =
      mkShell {
        name = "shell";
        nativeBuildInputs = [
          pkg-config
          ncurses5
          m4
          bison
          flex
          zlib
          coreboot-toolchain.i386
          autoconf
          automake
          gettext
          gnulib
          coreboot-utils
          innoextract
          freetype
          gnupg
        ];
      };
  };
}
