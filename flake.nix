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
        inherit libreboot;
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
        elfPayload = grub-payload;
        cbfs-files = {
          "grub.cfg" = ./grub-payload/grub.cfg;
          "grub-test.cfg" = ./grub-payload/grub-test.cfg;
        };
        coreboot = coreboot-t440p;
      };

      # a rom with grub-enforced signature checking. a public key must be embedded after the build.
      # example: cbfstool coreboot.bin add -n boot.key -f mypubkey.pub -t raw
      rom-securegrub = callPackage ./rom.nix {
        elfPayload = grub-payload;
        cbfs-files = {
          "grub.cfg" = ./grub-payload/grub-secureboot.cfg;
        };
        coreboot = coreboot-t440p;
      };

      seabios = callPackage ./seabios.nix {
        src = fetchgit libreboot-pins.seabios;
        inherit libreboot;
      };

      rom-seabios = callPackage ./rom.nix {
        coreboot = coreboot-t440p;
        elfPayload = "${seabios}/seabios_libgfxinit.elf";
        cbfs-files = {
          "vgaroms/seavgabios.bin" = "${seabios}/seavgabios.bin";
        };
        cbfs-ints = {
          "etc/pci-optionrom-exec" = 2;
          "etc/ps2-keyboard-spinup" = 3000;
          "etc/optionroms-checksum" = 0;
          "etc/only-load-option-roms" = 0;
        };
      };

      # a tinyconfig linux kernel for t440p
      tinylinux = callPackage ./tinylinux {};

      # small initramfs that include busybox
      busybox-initramfs = callPackage ./busybox-initramfs {
        inherit (pkgsCross.gnu32.pkgsStatic) busybox;
      };

      # qemu runner script for the tinylinux kernel
      tinylinux-qemu-runner = writeScriptBin "tinylinux-qemu-runner" ''
        #!${runtimeShell}
        ${qemu}/bin/qemu-system-x86_64 -enable-kvm -kernel ${tinylinux} -initrd ${busybox-initramfs} -serial stdio
      '';

      # rom that boots to a linux/busybox environment
      rom-tinylinux-busybox = callPackage ./rom.nix {
        coreboot = coreboot-t440p;
        linuxKernelPayload = tinylinux;
        linuxInitrd = busybox-initramfs;
        linuxCmdline = "earlyprintk=vga,keep ignore_loglevel init=/init";
      };

      # bootable disk image for the stock firmware. this is the only way to update the embedded controller firmware.
      lenovo-fw = callPackage ./lenovo-fw {};

      # all roms for ci
      default = stdenv.mkDerivation {
        name = "t440p-all-fw";
        dontBuild = true;
        dontUnpack = true;
        installPhase = ''
          mkdir $out
          cp -r ${rom} $out/rom-grub-basic
          cp -r ${rom-securegrub} $out/rom-grub-secure
          cp -r ${rom-seabios} $out/rom-seabios
        '';
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
