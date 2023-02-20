{ stdenv, src, libreboot, coreboot-toolchain, python3 }:

stdenv.mkDerivation {

  name = "seabios";

  inherit src;

  nativeBuildInputs = [ python3 coreboot-toolchain.i386 ];

  preConfigure = ''
    cp ${libreboot}/resources/seabios/config/libgfxinit .config
    make silentoldconfig
  '';

  installPhase = ''
    mkdir $out
    mv out/bios.bin.elf $out/seabios_libgfxinit.elf
    mv out/vgabios.bin $out/seavgabios.bin
  '';

}
