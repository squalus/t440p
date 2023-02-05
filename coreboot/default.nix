{ callPackage, fetchurl, fetchgit, lib, stdenv, haswell-mrc
, pkg-config, ncurses, m4, bison, flex, zlib, coreboot-toolchain, openssl
, python3, gnugrep
, libreboot, me
}:
stdenv.mkDerivation {

  name = "coreboot-t440p";

  src = callPackage ../coreboot-src.nix {};

  nativeBuildInputs = [
    pkg-config
    ncurses
    m4
    bison
    flex
    zlib
    coreboot-toolchain.i386
    openssl
    python3
    gnugrep
  ];

  postPatch = ''
    patchShebangs util/xcompile/xcompile
    patchShebangs util/genbuild_h/genbuild_h.sh
    patchShebangs util/scripts/ucode_h_to_bin.sh

    cp ${libreboot}/resources/coreboot/t440p_12mb/config/libgfxinit_corebootfb .config
    chmod -R ugo+rw .
    sed -i '/CONFIG_GBE_BIN_PATH=/d' .config
    sed -i '/CONFIG_IFD_BIN_PATH=/d' .config
    sed -i '/CONFIG_ME_BIN_PATH=/d' .config
    sed -i '/CONFIG_MRC_FILE=/d' .config

    echo 'CONFIG_GBE_BIN_PATH="${libreboot}/blobs/t440p/gbe.bin"' >> .config
    echo 'CONFIG_IFD_BIN_PATH="${libreboot}/blobs/t440p/ifd.bin"' >> .config
    echo 'CONFIG_ME_BIN_PATH="${me}"' >> .config
    echo 'CONFIG_MRC_FILE="${haswell-mrc}"' >> .config
  '';

  buildPhase = ''
    make -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mv build/coreboot.rom $out
  '';
}
