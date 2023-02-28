{ stdenv
, linuxPackages_6_1
, flex, bison, bc
, cmdline ? ""
, initramfs ? ""
}: stdenv.mkDerivation {

  name = "tinylinux";

  inherit (linuxPackages_6_1.kernel) src;

  nativeBuildInputs = [ flex bison bc ];

  configurePhase = ''
    cp ${./config} .config
  '';

  buildPhase = ''
    make -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    ls -la arch/x86/boot/bzImage
    cp arch/x86/boot/bzImage $out
  '';

}

