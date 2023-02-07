{ callPackage, fetchurl, fetchgit, lib, stdenv
, pkg-config, ncurses, m4, bison, flex, zlib, coreboot-toolchain, openssl
, python3, gnugrep
}:
{ name, config }:
stdenv.mkDerivation {

  inherit name;

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

    cp ${config} .config
    chmod -R u+w .
  '';

  buildPhase = ''
    make -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mv build/coreboot.rom $out
  '';
  passthru = {
    inherit config;
  };
}
