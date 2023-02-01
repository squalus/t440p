{ callPackage, fetchurl, lib, stdenv, grub2, haswell-mrc-bin
, pkg-config, ncurses, m4, bison, flex, zlib, toolchain, openssl
, python3
}:
let
  gbe-bin = "todo";
  ifd-bin = "todo";
  me-bin = "todo";
in
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
    toolchain
    openssl
    python3
  ];
  postPatch = ''
    patchShebangs util/xcompile/xcompile
    patchShebangs util/genbuild_h/genbuild_h.sh
    patchShebangs util/me_cleaner/me_cleaner.py
  '';

  buildPhase = ''
    cp ${./config} .config
    substituteInPlace .config \
      --subst-var-by haswell-mrc-bin ${haswell-mrc-bin} \
      --subst-var-by grub2 ${grub2} \
      --subst-var-by gbe-bin ${gbe-bin} \
      --subst-var-by ifd-bin ${ifd-bin} \
      --subst-var-by me-bin ${me-bin}

    cat .config

    make -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir $out
    dd if=build/coreboot.rom of=$out/8mb.rom bs=1M count=8
    dd if=build/coreboot.rom of=$out/4mb.rom bs=1M skip=8
  '';

  passthru = {
    inherit gbe-bin ifd-bin;
  };
}
