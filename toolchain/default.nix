{ callPackage, coreboot-toolchain }:
coreboot-toolchain.i386.overrideAttrs (old: {
  src = (callPackage (import ../coreboot-src.nix) {});
  buildPhase = old.buildPhase + ''
    make iasl CPUS=$NIX_BUILD_CORES DEST=$out
  '';
})
